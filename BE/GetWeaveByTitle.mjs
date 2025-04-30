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

    const { user_id, title } = event.body;

    if (!user_id || !title) {
        return {
            statusCode: 400,
            body: { message: "유효하지 않은 요청입니다." }
        };
    }

    try {
        const query = `
            SELECT 
                w.id as weave_id,
                w.title,
                w.description,
                w.create_user_id,
                w.type_id,
                u.nickname as creator_nickname
            FROM 
                Weave w
                INNER JOIN User u 
                    ON w.create_user_id = u.id
                LEFT JOIN Subscriptions s 
                    ON s.user_id = w.create_user_id  
                        AND s.target_user_id = ?  -- 작성자가 현재 사용자를 구독했는지 확인
            WHERE 
                w.title LIKE ?
                AND (
                    w.type_id IN (1, 2)  -- Global(1) 또는 Join(2) Weave는 기본 포함
                    OR (w.type_id = 3 AND w.privacy_id = 3)  -- Local(3) Weave 중 Public(3)
                    OR (w.type_id = 3 AND w.privacy_id = 2 AND s.id IS NOT NULL)  
                        -- Local(3) Weave 중 Friend Only(2)이며 **작성자가 사용자를 구독한 경우**
                    OR (w.create_user_id = ?)  -- 본인이 만든 Weave는 모두 표시
                )
            ORDER BY 
                LENGTH(w.title) ASC
        `;

        const results = await executeQuery(query, [user_id, `%${title}%`, user_id]);

        if (results.length === 0) {
            return {
                statusCode: 200,
                body: {
                    message: "검색 결과가 없습니다.",
                    weaves: []
                }
            };
        }

        return {
            statusCode: 200,
            body: {
                message: "성공",
                weaves: results
            }
        };

    } catch (error) {
        console.error('Error in GetWeaveByTitle:', error);
        return {
            statusCode: 502,
            body: { message: "데이터가 정상 처리되지 않았습니다." }
        };
    } finally {
        await closeConnection();
    }
};
