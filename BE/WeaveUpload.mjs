import { verifyAccessToken } from './jwt.mjs';
import { closeConnection, executeQuery } from './dbClient.mjs';

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
      body: { message: 'Missing required fields' },
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
      body: { message: 'Weave created successfully', weave_id: result.insertId },
    };
  } catch (error) {
    console.error('Error creating weave:', error);
    return {
      statusCode: 500,
      body: { message: 'Error creating weave' },
    };
  } finally {
    await closeConnection();
  }
};
