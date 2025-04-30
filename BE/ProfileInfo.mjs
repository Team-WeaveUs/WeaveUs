import { getConnection, closeConnection, executeQuery } from 'dbclient';
import { verifyAccessToken } from 'jwt';

export const handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') {
    return {
        statusCode: 200,
        body: {},
    };
  }
  const verifyed = verifyAccessToken(event);

  if (verifyed.code !== 1) {
    return {
      statusCode: verifyed.status,
      body: { message: verifyed.message, event:verifyed.error },
    };
  }

  const { user_id, target_user_id, startat = 0, post_count = 10 } = event.body;

  if (!user_id || !target_user_id || !post_count) {
    return {
      statusCode: 400,
      body: { message: "유효하지 않은 요청입니다. " },
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
        statusCode: 505,
        body: { message: "사용자를 찾을 수 없습니다." },
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

    const normalizeStartAt = /^-?\d+$/.test(startat) ? Number(startat) : 0;
    const normalizePostCount = /^-?\d+$/.test(post_count) ? Number(post_count) : 10;

    if (user_id == target_user_id) {
      ret = await executeQuery(
        `SELECT p.id as post_id, m.content_url as img, p.location as loc 
          FROM Post as p, Media as m
          WHERE p.user_id = ? AND m.id = p.thumbnail_media_id 
          ORDER BY p.id DESC LIMIT ${normalizeStartAt},${normalizePostCount}`,
        [target_user_id]);
    } else {
      // 본인 프로필 탐색이 아닐경우 public 게시물만 SELECT
      ret = await executeQuery(
        `SELECT p.id as post_id, m.content_url as img, p.location as loc 
          FROM Post as p, Media as m
          WHERE p.user_id = ? AND m.id = p.thumbnail_media_id AND p.privacy_id = 3 
          ORDER BY p.id DESC LIMIT ${normalizePostCount}`,
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
      statusCode: 502,
      body: { message: '데이터가 정상 처리되지 않았습니다. '}
    };
  }
};
