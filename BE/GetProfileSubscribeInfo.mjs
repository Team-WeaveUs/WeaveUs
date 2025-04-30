import { verifyAccessToken } from 'jwt';
import { closeConnection, executeQuery } from 'dbclient';

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
        body: { message: verifyed.message },
      };
    }

    const { user_id, target_user_id, selection_type } = event.body;

    if (!target_user_id || selection_type == null || (selection_type == 1 && user_id != target_user_id)) {
        return {
            statusCode: 400,
            body: { message: "유효하지 않은 요청입니다. " }
        };
    }

    try {
        let query = `SELECT u.id, u.nickname, u.media_url
                        FROM Subscriptions as s
                            INNER JOIN User as u 
                                ON s.user_id = u.id
                        WHERE target_user_id = ? 
                            AND valid = 1`;
        let message = `${target_user_id} 를 구독한 사람 조회 성공`

        if(selection_type == 1) {
            query = `SELECT u.id, u.nickname, u.media_url
                        FROM Subscriptions as s
                            INNER JOIN User as u 
                                ON s.target_user_id = u.id
                        WHERE user_id = ? 
                            AND valid = 1`;
            message = `${target_user_id} 가 구독한 사람 조회 성공`
        }
        const result = await executeQuery(query, [target_user_id]);

        return {
            statusCode: 200,
            body: {
                message: message,
                data: result
            }
        };
    } catch (error) {
        console.error("<Error> GetProfileSubscribeInfo - Query Failed >> ", error);
        return {
            statusCode: 502,
            body: { message: "데이터가 정상 처리되지 않았습니다. " }
        };
    } finally {
        await closeConnection();
    }
};
