// updateUser.js
import bcrypt from 'bcryptjs';
import { getConnection, closeConnection, executeQuery } from 'dbClient';

export const handler = async (event) => {
    // event 객체에서 파라미터 추출
    const { id, pw, name, nickname, number, gender, is_owner } = event;

    // 필수 필드 확인
    if (!id) {
        return {
            statusCode: 400,
            body: { message: "유효하지 않은 요청입니다. " },
        };
    }

    try {
        // 사용자 존재 여부 확인
        let ret = await executeQuery(
            `SELECT id FROM User WHERE account_id = ?`,
            [id]
        );

        if (ret.length === 0) {
            console.error('<Error> UpdateUser - 해당 ID의 사용자가 존재하지 않습니다.');
            await closeConnection();
            return {
                statusCode: 505,
                body: { message: "사용자를 찾을 수 없습니다." },
            };
        }

        // 업데이트할 필드와 값 설정
        const fields = [];
        const values = [];

        if (pw) {
            const hashed_pw = await bcrypt.hash(pw, 10);
            fields.push('account_pw = ?');
            values.push(hashed_pw);
        }
        if (name) {
            fields.push('name = ?');
            values.push(name);
        }
        if (nickname) {
            fields.push('nickname = ?');
            values.push(nickname);
        }
        if (number) {
            // 전화번호 중복 확인
            const numberCheck = await executeQuery(
                `SELECT id FROM User WHERE number = ? AND account_id != ?`,
                [number, id]
            );
            if (numberCheck.length !== 0) {
                console.error('<Error> UpdateUser - 동일한 전화번호가 존재합니다.');
                await closeConnection();
                return {
                    statusCode: 409,
                    headers: headers,
                    body: JSON.stringify({ message: "전화번호 중복을 확인하세요." }),
                };
            }
            fields.push('number = ?');
            values.push(number);
        }
        if (gender) {
            fields.push('gender = ?');
            values.push(gender);
        }
        if (is_owner !== undefined) {
            fields.push('is_owner = ?');
            values.push(is_owner);
        }

        if (fields.length === 0) {
            return {
                statusCode: 400,
                headers: headers,
                body: JSON.stringify({ message: "업데이트할 필드가 제공되지 않았습니다." }),
            };
        }

        values.push(id);

        // 사용자 정보 업데이트
        await executeQuery(
            `UPDATE User SET ${fields.join(', ')} WHERE account_id = ?`,
            values
        );

        await closeConnection();

        return {
            statusCode: 200,
            headers: headers,
            body: JSON.stringify({ message: "사용자 정보가 성공적으로 업데이트되었습니다." }),
        };

    } catch (error) {
        console.error('<Error> UpdateUser - 쿼리 실행 중 오류 발생:', error);
        await closeConnection();
        return {
            statusCode: 500,
            headers: headers,
            body: JSON.stringify({ message: "서버 오류로 인해 사용자 정보 업데이트에 실패했습니다." }),
        };
    }
};
