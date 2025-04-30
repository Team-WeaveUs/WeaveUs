import { verifyAccessToken } from 'jwt';
import { executeQuery, closeConnection } from 'dbclient';

export const handler = async (event) => {
  const verified = verifyAccessToken(event);
  if (verified.code !== 1) {
    return {
      statusCode: verified.status,
      body: { message: verified.message },
    };
  }

  const { user_id, post_id } = event.body;

  if (!user_id || !post_id) {
    return {
      statusCode: 400,
      body: { message: '유효하지 않은 요청입니다.' },
    };
  }

  try {
    const query = `
      SELECT c.id AS comment_id, c.content, c.created_at, u.id as user_id, u.nickname, u.media_url
      FROM Comment c
      JOIN User u ON c.user_id = u.id
      WHERE c.post_id = ?
      ORDER BY c.created_at ASC
    `;
    const comments = await executeQuery(query, [post_id]);

    return {
      statusCode: 200,
      body: { comments },
    };
  } catch (error) {
    console.error('DB Error:', error);
    return {
      statusCode: 502,
      body: { message: '댓글 조회 중 오류가 발생했습니다.' },
    };
  } finally {
    await closeConnection();
  }
};
