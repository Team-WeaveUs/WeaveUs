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

    const { user_id, weave_id, startat, offset } = event.body;  // 기본값 설정

    // 입력값 유효성 검사
    if (user_id == null || weave_id == null) {
        return {
            statusCode: 400,
            body: { message: "유효하지 않은 요청입니다."}
        };
    }
    
    // weave_id 정규화
    const normalizedWeaveId = /^-?\d+$/.test(String(weave_id)) ? Number(weave_id) : null;
    
    // startat, offset 정규화
    const normalizedStartat = /^-?\d+$/.test(String(startat)) ? Number(startat) : 0;
    const normalizedOffset = /^-?\d+$/.test(String(offset)) ? Number(offset) : 10;

    // 정규화 후 유효성 검사
    if (normalizedWeaveId === null) {
        return {
            statusCode: 400,
            body: { message: "유효하지 않은 요청입니다." }
        };
    }

    if (normalizedStartat < 0 || normalizedOffset <= 0) {
        return {
            statusCode: 400,
            body: { message: "유효하지 않은 요청입니다." }
        };
    }

    try {
        const query = `
            SELECT 
                id as post_id
            FROM 
                Post
            WHERE 
                weave_id = ?
            ORDER BY 
                likes DESC
            LIMIT ${normalizedStartat}, ${normalizedOffset}
        `;

        const results = await executeQuery(query, [normalizedWeaveId]);

        if (results.length === 0) {
            return {
                statusCode: 200,
                body: {
                    message: '게시물이 없습니다.',
                    post_id: []
                }
            };
        }

        // post_id 배열로 변환
        const postId = results.map(row => row.post_id);

        return {
            statusCode: 200,
            body: {
                message: '성공',
                post_id: postId,
                next_startat: normalizedStartat + results.length  // 다음 페이지 시작점
            }
        };

    } catch (error) {
        console.error('Error in getWeavePostsSortedByLikes:', error);
        return {
            statusCode: 502,
            body: { message: '데이터가 정상 처리되지 않았습니다.' }
        };
    } finally {
        await closeConnection();
    }
};
