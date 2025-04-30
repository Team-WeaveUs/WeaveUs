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

  const { title, description, privacy_id, user_id, type_id } = event.body;

  if(!title || !description || !privacy_id || !user_id || !type_id) {
    return {
      statusCode: 400,
      body: { message: '유효하지 않은 요청입니다.' },
    };
  }

  try {
    const query = `INSERT INTO Weave 
    (title, description, privacy_id, create_user_id, type_id) VALUES 
    (?, ?, ?, ?, ?)`;
    const values = [title, description, privacy_id, user_id, type_id];
    const result = await executeQuery(query, values);

    return {
      statusCode: 200,
      body: { message: '위브 생성 성공', weave_id: result.insertId },
    };
  } catch (error) {
    console.error('Error creating weave:', error);
    return {
      statusCode: 502,
      body: { message: '데이터가 정상 처리되지 않았습니다.' },
    };
  } finally {
    await closeConnection();
  }
};
