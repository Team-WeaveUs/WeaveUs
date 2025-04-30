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
    const user_id = event.body.user_id;
    if (!user_id) {
        return {
            statusCode: 505,
            body: { message: '사용자를 찾을 수 없습니다. ' }
        };
    }
    try {
        // 구독 중인(valid=1) 사용자들의 최신 게시물 ID 목록을 가져오는 쿼리
        const query = `
            SELECT 
                p.id as post_id
            FROM 
                Post p
                INNER JOIN Subscriptions s 
                    ON p.user_id = s.target_user_id
            WHERE 
                s.user_id = ?
                AND s.valid = 1  -- 구독 상태인 경우만 포함
            ORDER BY 
                p.created_at DESC
        `;

        const results = await executeQuery(query, [user_id]);

        if (results.length === 0) {
            // 구독 게시물이 없으면 전체 게시물 중 최신 1개 반환
            const fallbackQuery = `
                SELECT id as post_id FROM Post ORDER BY updated_at DESC LIMIT 10
            `;
            const fallbackResults = await executeQuery(fallbackQuery);
            if (fallbackResults.length === 0) {
                return {
                    statusCode: 200,
                    body: {
                        message: '게시물이 없습니다.',
                        post_id: []
                    }
                };
            }
            return {
                statusCode: 200,
                body: {
                    message: '구독 게시물이 없어 최신 게시물들을 반환합니다.',
                    post_id: fallbackResults.map(row => row.post_id)
                }
            };
        }

        // post_id 배열로 변환
        const postIds = results.map(row => row.post_id);

        return {
            statusCode: 200,
            body: {
                message: '성공',
                post_id: postIds
            }
        };

    } catch (error) {
        console.error('Error in main page:', error);
        return {
            statusCode: 502,
            body: { message: '데이터가 정상 처리되지 않았습니다. ' }
        };
    } finally {
        await closeConnection();
    }
};
