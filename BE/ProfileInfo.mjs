import { getConnection, closeConnection, executeQuery } from './dbClient.mjs';
import { verifyRefreshToken, createAccessToken, createRefreshToken } from './jwt.mjs';

export const handler = async (event) => {
  const verifyed = verifyRefreshToken(event);

  if (verifyed.code !== 1) {
    return {
      statusCode: verifyed.status,
      body: { message: verifyed.message },
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
    let ret = await executeQuery(
      `SELECT id, account_id, account_pw , nickname
          FROM User 
          WHERE 
            account_id LIKE ?`, 
      [account_id]);

  } catch (error) {
    return {
      statusCode: 500,
      body: { message: 'Internal Server Error' },
    };
  }
};
