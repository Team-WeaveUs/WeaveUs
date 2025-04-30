import { verifyAccessToken } from 'jwt';
import { closeConnection, executeQuery } from 'dbclient';

export const handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') {
    return {
      statusCode: 200,
      body: {},
    };
  }

  const verified = verifyAccessToken(event);

  if (verified.code !== 1) {
    return {
      statusCode: verified.status,
      body: { message: verified.message },
    };
  }

  const { user_id, target_user_id } = event.body;

  if (!user_id || !target_user_id || user_id === target_user_id) {
    return {
      statusCode: 400,
      body: { message: "유효하지 않은 요청입니다." },
    };
  }

  try {
    const checkQuery = `
      SELECT * FROM Subscriptions 
      WHERE user_id = ? AND target_user_id = ?
    `;
    const result = await executeQuery(checkQuery, [user_id, target_user_id]);

    let subscribe_status = 1;

    if (result.length === 0) {
      const insertQuery = `
        INSERT INTO Subscriptions (user_id, target_user_id, valid)
        VALUES (?, ?, 1)
      `;
      await executeQuery(insertQuery, [user_id, target_user_id]);
    } else {
      subscribe_status = result[0].valid === 1 ? 0 : 1;
      const updateQuery = `
        UPDATE Subscriptions SET valid = ? 
        WHERE user_id = ? AND target_user_id = ?
      `;
      await executeQuery(updateQuery, [subscribe_status, user_id, target_user_id]);
    }

    return {
      statusCode: 200,
      body: {
        message: "구독 상태가 변경되었습니다.",
        subscribe_status,
      },
    };
  } catch (error) {
    console.error("<Error> SubscribeUpdate - Query Failed >> ", error);
    return {
      statusCode: 502,
      body: { message: "데이터가 정상 처리되지 않았습니다." },
    };
  } finally {
    await closeConnection();
  }
};
