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

    const { user_id, add_user_id, weave_id } = event.body;

    if (!user_id || !add_user_id || !weave_id) {
        return {
            statusCode: 400,
            body: { message: "유효하지 않은 요청입니다." }
        };
    }

    // add_user_id와 weave_id 정규화
    const normalizedAddUserId = /^-?\d+$/.test(String(add_user_id)) ? Number(add_user_id) : null;
    const normalizedWeaveId = /^-?\d+$/.test(String(weave_id)) ? Number(weave_id) : null;

    if (normalizedAddUserId === null || normalizedWeaveId === null) {
        return {
            statusCode: 400,
            body: { message: "유효하지 않은 요청입니다." }
        };
    }

    try {
        // 권한 체크와 중복 체크를 한 번에 수행
        const checkQuery = `
        SELECT 
            w.create_user_id,
            w.type_id as weave_type,
            ws.id as existing_share
        FROM 
            Weave w
            LEFT JOIN WeaveSharedUser ws 
                ON ws.weave_id = w.id 
                    AND ws.user_id = ?
        WHERE 
            w.id = ? 
            AND w.create_user_id = ? 
            AND w.type_id = 3
        `;

        const checkResult = await executeQuery(checkQuery, [normalizedAddUserId, normalizedWeaveId, user_id]);

        if (checkResult.length === 0) {
            return {
                statusCode: 506,
                body: { message: "위브를 찾을 수 없습니다." }
            };
        }

        const weaveInfo = checkResult[0];

        if (weaveInfo.existing_share) {
            return {
                statusCode: 605,
                body: { message: "이미 추가된 사용자입니다." }
            };
        }

        // WeaveSharedUser에 새 데이터 추가
        const insertQuery = `
            INSERT INTO WeaveSharedUser (weave_id, user_id)
            VALUES (?, ?)
        `;

        await executeQuery(insertQuery, [normalizedWeaveId, normalizedAddUserId]);

        return {
            statusCode: 200,
            body: {
                message: "성공적으로 사용자를 추가했습니다."
            }
        };

    } catch (error) {
        console.error('Error in addLocalWeavePermission:', error);
        return {
            statusCode: 502,
            body: { message: "데이터가 정상 처리되지 않았습니다. "}
        };
    } finally {
        await closeConnection();
    }
};
