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
    
    const { user_id, post_id, content } = event.body;

    if (!user_id || !post_id || !content) {
        return {
            statusCode: 400,
            body: { message: "유효하지 않은 요청입니다." },
        };
    }
    
    try {
        const result = await executeQuery(
            `INSERT INTO Comment (user_id, post_id, content) 
             VALUES (?, ?, ?)`,
            [user_id, post_id, content]
        );
        
        return {
            statusCode: 200,
            body: { 
                message: "등록 성공하였습니다",
                comment_id: result.insertId
            },
        };
        
    } catch(error) {
        return {
            statusCode: 502,
            body: { message: "데이터가 정상 처리되지 않았습니다." },
        };
    } finally {
        await closeConnection();
    }
};