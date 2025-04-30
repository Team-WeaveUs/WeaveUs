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

    const { user_id, post_id } = event.body;

    // 먼저 post_id가 유효한 입력인지 확인
    if (!user_id || !post_id) {
        return {
            statusCode: 400,
            body: { message: "유효하지 않은 요청입니다." }
        };
    }
    
    // 배열로 변환
    const postIdArray = Array.isArray(post_id) ? post_id : [post_id];
    
    // 숫자로 정규화
    const normalizedPostId = postIdArray
        .filter(id => /^-?\d+$/.test(String(id)))
        .map(Number);

    // 정규화 후 유효한 ID가 있는지 확인
    if (normalizedPostId.length === 0) {
        return {
            statusCode: 400,
            body: { message: "유효하지 않은 요청입니다." }
        };
    }

    try {
        const query = `
            SELECT 
                p.*,
                w.id AS weave_id,
                w.title AS weave_title,
                w.type_id AS weave_type,
                u.nickname,
                u.media_url AS user_media_url,
                IFNULL(s.valid, 0) AS sub_valid,
                COUNT(DISTINCT c.id) AS comment_count,
                GROUP_CONCAT(DISTINCT m.content_url) AS media_url
            FROM 
                Post p
                INNER JOIN Weave w ON p.weave_id = w.id
                INNER JOIN User u ON p.user_id = u.id
                LEFT JOIN Subscriptions s ON s.user_id = ? 
                    AND s.target_user_id = p.user_id
                LEFT JOIN Comment c ON c.post_id = p.id
                LEFT JOIN Media m ON m.post_id = p.id
            WHERE 
                p.id IN (${normalizedPostId.join(',')})
            GROUP BY 
                p.id
            ORDER BY FIELD(p.id, ${normalizedPostId.join(',')})
        `;

        console.log('실행될 쿼리:', query);
        console.log('쿼리 파라미터:', [user_id]);
        
        const results = await executeQuery(query, [user_id]);
        
        console.log('쿼리 결과:', results);

        if (results.length === 0) {
            return {
                statusCode: 507,
                body: { message: "게시물을 찾을 수 없습니다." }
            };
        }

        return {
            statusCode: 200,
            body: {
                message: '성공',
                post: results
            }
        };

    } catch (error) {
        console.error('Error in getPostSimple:', error);
        return {
            statusCode: 502,
            body: { message: '데이터가 정상 처리되지 않았습니다. ' }
        };
    } finally {
        await closeConnection();
    }
};
