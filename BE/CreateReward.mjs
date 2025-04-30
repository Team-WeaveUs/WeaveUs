import { verifyAccessToken } from 'jwt';
import { closeConnection, executeQuery } from 'dbclient';

/**
 * 리워드 생성 핸들러
 * 사용자의 리워드를 생성합니다.
 * 
 * @param {Object} event - API Gateway 이벤트 객체
 * @param {Object} event.headers - 요청 헤더
 * @param {Object} event.body - 요청 본문
 * @returns {Object} 응답 객체
 */
export const handler = async (event) => {
    // JWT 토큰 검증
    const verified = verifyAccessToken(event);

    // 토큰이 유효하지 않은 경우 에러 반환
    if (verified.code !== 1) {
        return {
            statusCode: verified.status,
            body: { message: verified.message }
        };
    }

    // 요청에서 사용자 ID 추출
    const user_id = event.body.user_id;
    if (!user_id) {
        return {
            statusCode: 505,
            body: { message: '사용자를 찾을 수 없습니다. ' }
        };
    }

    // 필수 필드 검증
    const { title, description, validity } = event.body;
    if (!title || !description || !validity) {
        return {
            statusCode: 400,
            body: { message: '리워드 제목, 설명, 유효기간은 필수입니다.' }
        };
    }

    try {
        // 리워드 생성 SQL 쿼리 (사업자 확인 포함)
        const query = `
            INSERT INTO Reward (
                user_id,
                title,
                description,
                validity
            )
            SELECT 
                ?,
                ?,
                ?,
                ?
            FROM User
            WHERE id = ? AND is_owner = 1
        `;

        // 쿼리 파라미터
        const params = [
            user_id,
            title,
            description,
            validity,
            user_id
        ];

        // 쿼리 실행
        const result = await executeQuery(query, params);

        // 삽입된 행이 없는 경우 (사업자가 아닌 경우)
        if (result.affectedRows === 0) {
            return {
                statusCode: 404,
                body: { message: '접근 권한이 없습니다.' }
            };
        }

        return {
            statusCode: 200,
            body: {
                message: '리워드가 성공적으로 생성되었습니다.'
            }
        };

    } catch (error) {
        // // 에러 발생 시 로그 기록 및 에러 응답 반환
        // console.error('Error in create reward:', error);
        return {
            statusCode: 502,
            body: { message: '데이터가 정상 처리되지 않았습니다. ' }
        };
    }
}; 