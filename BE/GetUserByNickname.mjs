import { verifyAccessToken } from 'jwt';
import { closeConnection, executeQuery } from 'dbclient';

export const handler = async (event) => {
    const verified = verifyAccessToken(event);

    if (verified.code !== 1) {
        return {
            statusCode: verified.status,
            body: { message: verified.message }
        };
    }

    const { user_id, nickname } = event.body;

    if (!user_id || !nickname) {
        return {
            statusCode: 400,
            body: { message: "유효하지 않은 요청입니다." }
        };
    }

    try {
        const query = `
            SELECT 
                id as user_id,
                nickname,
                media_url
            FROM 
                User
            WHERE 
                nickname LIKE ?
            ORDER BY 
                LENGTH(nickname) ASC
        `;

        const results = await executeQuery(query, [`%${nickname}%`]);

        if (results.length === 0) {
            return {
                statusCode: 200,
                body: {
                    message: "검색 결과가 없습니다.",
                    users: []
                }
            };
        }

        return {
            statusCode: 200,
            body: {
                message: "성공",
                users: results
            }
        };

    } catch (error) {
        console.error('Error in getLocalWeavePermission:', error);
        return {
            statusCode: 502,
            body: { message: "데이터가 정상 처리되지 않았습니다. " }
        };
    } finally {
        await closeConnection();
    }
};
