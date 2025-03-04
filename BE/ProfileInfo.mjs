import { getConnection, closeConnection, executeQuery } from './dbClient.mjs';
import { verifyAccessToken } from './jwt.mjs';

export const handler = async (event) => {
  const verifyed = verifyAccessToken(event);

  if (verifyed.code !== 1) {
    return {
      statusCode: verifyed.status,
      body: { message: verifyed.message, event:verifyed.error },
    };
  }

  const { user_id, target_user_id, post_count } = event.body;

  // 사용자 유효성 검증
  if (!user_id || !target_user_id || !post_count) {
    return {
      statusCode: 400,
      body: { message: "아이디와 비밀번호를 입력하세요." },
    };
  }


  try {
    //유저 프로필 정보 
    let ret = await executeQuery(
      `SELECT id, nickname, media_url, likes, subscribes 
        FROM User 
        WHERE id = ?`,
      [target_user_id]);

    if (ret.length != 1) {
      await closeConnection();
      return {
        statusCode: 400,
        body: { message: "유저 정보가 없습니다." },
      };
    }

    let response = {
      message: "프로필 정보 조회 성공",   //수집 성공시만 반환할 변수라 미리 추가

      user_id: ret[0].id,
      nickname: ret[0].nickname,
      img: ret[0].media_url,
      likes: ret[0].likes,
      subscribes: ret[0].subscribes
    };

    const normalizePostCount = /^-?\d+$/.test(post_count) ? Number(post_count) : 0;

    if (user_id == target_user_id) {
      ret = await executeQuery(
        `SELECT id as post_id, media_url as img, location as loc 
          FROM Post 
          WHERE user_id = ? 
          ORDER BY id DESC LIMIT ${normalizePostCount}`,
        [target_user_id]);
    } else {
      // 본인 프로필 탐색이 아닐경우 public 게시물만 SELECT
      ret = await executeQuery(
        `SELECT id as post_id, media_url as img, location as loc 
          FROM Post 
          WHERE user_id = ? AND privacy_id = 3 
          ORDER BY id DESC LIMIT ${normalizePostCount}`,
        [target_user_id]);
    }

    response["post_list"] = ret;
      
    await closeConnection();
    return {
      statusCode: 200,
      body: response,
    };

  } catch (error) {
    await closeConnection();
    return {
      statusCode: 500,
      body: { message: 'Internal Server Error'},
    };
  }
};
