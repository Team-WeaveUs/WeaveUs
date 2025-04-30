// GetRewards.mjs

import { verifyAccessToken } from 'jwt';               
import { executeQuery, closeConnection } from 'dbclient'; 

export const handler = async (event) => {
  // 1. 액세스 토큰 검증
  const verified = verifyAccessToken(event);
  if (verified.code !== 1) {
    return {
      statusCode: verified.status,
      body: { message: verified.message }
    };
  }

  // 2. 입력 파라미터 추출
  const { user_id, reward_id } = event.body;
  if (!user_id && !reward_id) {
    return {
      statusCode: 400,
      body: { message: '유효하지 않은 요청입니다.' }
    };
  }

  try {
    // 3. reward_id가 주어지면 해당 보상만 조회
    if (reward_id) {
      const query = `
        SELECT
          id          AS reward_id,
          title,
          description,
          validity
        FROM Reward
        WHERE id = ?
      `;
      const results = await executeQuery(query, [reward_id]);
      if (results.length === 0) {
        return {
          statusCode: 404,
          body: { message: '해당 리워드를 찾을 수 없습니다.' }
        };
      }
      return {
        statusCode: 200,
        body: {
          reward: results
        }
      };
    }

    // 4. reward_id가 없으면 user_id 기준으로 전체 목록 조회
    const listQuery = `
      SELECT
        id          AS reward_id,
        title,
        description,
        validity
      FROM Reward
      WHERE user_id = ?
      ORDER BY id DESC
    `;
    const rewards = await executeQuery(listQuery, [user_id]);

    return {
      statusCode: 200,
      body: {
        rewards
      }
    };
  } catch (error) {
    console.error('GetRewards Error:', error);
    return {
      statusCode: 502,
      body: { message: '데이터 조회 중 오류가 발생했습니다.' }
    };
  } finally {
    await closeConnection();
  }
};
