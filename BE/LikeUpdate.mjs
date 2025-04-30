import { verifyAccessToken } from 'jwt';
import { closeConnection, executeQuery } from 'dbclient';

export const handler = async (event) => {
    if (event.httpMethod === 'OPTIONS') {
      return {
          statusCode: 200,
          body: {},
      };
    }
    const verifyed = verifyAccessToken(event);
  
    if (verifyed.code !== 1) {
      return {
        statusCode: verifyed.status,
        body: { message: verifyed.message },
      };
    }

    const { user_id, post_id } = event.body;

    if (!user_id || !post_id) {
        return {
            statusCode: 400,
            body: { message: "user_id, post_id 입력하세요." }
        };
    }

    try {
        // 좋아요 등록 여부 확인
        const likeCheckQuery = `SELECT * FROM Likes WHERE user_id = ? AND post_id = ?`;
        const likeCheckResult = await executeQuery(likeCheckQuery, [user_id, post_id]);

        let like_status = 1;

        if (likeCheckResult.length == 0) {
            const likeInsertQuery = `INSERT INTO Likes (user_id, post_id) VALUES (?, ?)`;
            await executeQuery(likeInsertQuery, [user_id, post_id]);
        } else {
            like_status = likeCheckResult[0].valid == 1 ? 0 : 1
            const likeDeleteQuery = `UPDATE Likes SET valid = ? WHERE user_id = ? AND post_id = ?`;
            await executeQuery(likeDeleteQuery, [like_status ,user_id, post_id]);
        }

        // 총 좋아요 수 조회
        const likeCountQuery = `SELECT likes AS like_count FROM Post WHERE id = ?`;
        const likeCountResult = await executeQuery(likeCountQuery, [post_id]);

        return {
            statusCode: 200,
            body: {
                like_count: likeCountResult[0].like_count,
                like_status: like_status
            }
        };
    } catch (error) {
        console.error("<Error> Like Post - Query Failed >> ", error);
        return {
            statusCode: 502,
            body: { message: "데이터가 정상 처리되지 않았습니다. " }
        };
    } finally {
        await closeConnection();
    }
};
