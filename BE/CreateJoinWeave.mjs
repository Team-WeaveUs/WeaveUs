// CreateJoinWeave.mjs

import { verifyAccessToken } from 'jwt';
import { executeQuery, closeConnection } from 'dbclient';

export const handler = async (event) => {
  // 1) JWT 검증
  const verified = verifyAccessToken(event);
  if (verified.code !== 1) {
    return {
      statusCode: verified.status,
      body: { message: verified.message }
    };
  }

  // 2) 요청 파라미터 추출 (privacy_id = 3, type_id = 2 고정)
  const {
    user_id,
    title,
    description,
    reward_id,
    reward_condition_id,
    reward_validity
  } = event.body;

  // 3) 필수 파라미터 검증
  if (
    !user_id ||
    !title ||
    !description ||
    reward_id == null ||
    reward_condition_id == null ||
    reward_validity == null
  ) {
    return {
      statusCode: 400,
      body: { message: "유효하지 않은 요청입니다. 모든 필드를 확인하세요." }
    };
  }

  try {
    // 4) 오너 여부 확인
    const ownerRows = await executeQuery(
      'SELECT is_owner FROM User WHERE id = ?',
      [user_id]
    );

    if (ownerRows.length === 0) {
      return {
        statusCode: 404,
        body: { message: "사용자를 찾을 수 없습니다." }
      };
    }
    if (ownerRows[0].is_owner !== 1) {
      return {
        statusCode: 403,
        body: { message: "접근 권한이 없습니다." }
      };
    }

    // 5) Join 위브 생성 (type_id=2, privacy_id=3, 보상 정보 포함)
    const result = await executeQuery(
      `INSERT INTO Weave
         (title,
          description,
          privacy_id,
          create_user_id,
          type_id,
          reward_id,
          reward_condition_id,
          reward_validity)
       VALUES (?, ?, 3, ?, 2, ?, ?, ?)`,
      [ title, description, user_id, reward_id, reward_condition_id, reward_validity ]
    );

    // 6) 성공 응답
    return {
      statusCode: 200,
      body: {
        message: "Join 위브 생성 및 보상 정보 저장 성공",
        weave_id: result.insertId
      }
    };

  } catch (error) {
    console.error("Error in CreateJoinWeave:", error);
    return {
      statusCode: 502,
      body: { message: "데이터 처리 중 오류가 발생했습니다." }
    };

  } finally {
    // 7) DB 연결 정리
    await closeConnection();
  }
};
