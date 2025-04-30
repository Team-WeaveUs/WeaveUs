import { verifyAccessToken } from 'jwt';
import { closeConnection, executeQuery } from 'dbclient';

/**
 * 리워드 지급 조건 생성 핸들러
 * 사용자의 RewardCondition을 생성합니다.
 * 
 * @param {Object} event - API Gateway 이벤트 객체
 * @param {Object} event.headers - 요청 헤더
 * @param {Object} event.body - 요청 본문
 * @returns {Object} 응답 객체
 */
export const handler = async (event) => {
    // JWT 토큰 검증
    const verified = verifyAccessToken(event);

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
            body: { message: '사용자를 찾을 수 없습니다.' }
        };
    }

    // 필수 필드 검증 및 enum 체크
    const { name, description, type, reward_count, like_threshold } = event.body;
    const ALLOWED_TYPES = ['RANDOM_AUTHOR', 'TOP_LIKED', 'RANDOM_THRESHOLD', 'FIRST_N', 'CUSTOM'];
    if (!name || !description || !type || !reward_count) {
        return {
            statusCode: 400,
            body: {
                message: '조건명, 설명, 타입, 지급 대상 개수는 필수입니다.'
            }
        };
    }
    if (!ALLOWED_TYPES.includes(type)) {
        return {
            statusCode: 400,
            body: {
                message: `type은 다음 중 하나여야 합니다: ${ALLOWED_TYPES.join(', ')}`
            }
        };
    }
    // like_threshold는 type이 RANDOM_THRESHOLD 또는 TOP_LIKED일 때만 필수
    let likeThresholdToUse = null;
    if (type === 'RANDOM_THRESHOLD' || type === 'TOP_LIKED') {
        if (like_threshold === undefined || like_threshold === null) {
            return {
                statusCode: 400,
                body: { message: `type이 ${type}일 때 like_threshold는 필수입니다.` }
            };
        }
        likeThresholdToUse = like_threshold;
    }
    // parameters는 없어도 됨
    // is_active는 기본값 1
    const is_active = 1;
    const parameters = null;

    try {
        // RewardCondition 생성 SQL 쿼리
        // 사업자(오너) 확인을 위한 INSERT ... SELECT 쿼리
        const query = `
            INSERT INTO RewardCondition (
                user_id,
                name,
                description,
                type,
                reward_count,
                like_threshold,
                parameters,
                is_active
            )
            SELECT ?, ?, ?, ?, ?, ?, ?, ?
            FROM User
            WHERE id = ? AND is_owner = 1
        `;
        const params = [
            user_id,
            name,
            description,
            type,
            reward_count,
            likeThresholdToUse,
            parameters,
            is_active,
            user_id
        ];

        const result = await executeQuery(query, params);
        // 삽입된 행이 없는 경우 (사업자가 아닌 경우)
        if (result.affectedRows === 0) {
            return {
                statusCode: 404,
                body: { message: '접근 권한이 없습니다.' }
            };
        }
        if (!result.insertId) {
            return {
                statusCode: 502,
                body: { message: 'RewardCondition 생성에 실패했습니다.' }
            };
        }

        return {
            statusCode: 200,
            body: {
                message: 'RewardCondition이 성공적으로 생성되었습니다.',
                id: result.insertId
            }
        };
    } catch (error) {
        console.error('Error in create reward condition:', error);
        return {
            statusCode: 502,
            body: { message: '데이터가 정상 처리되지 않았습니다.' }
        };
    }
};
