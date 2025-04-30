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

  const { user_id, privacy_id, weave_id, content, location, area_id, files } = event.body;

  if (user_id == null || privacy_id == null || (privacy_id < 1 || 3 < privacy_id) || weave_id == null || content == null || files == null || files.length == 0) {
    return {
      statusCode: 400,
      body: { message: '유효하지 않은 요청입니다. ' },
    };
  }
  
  try {
    let result = await executeQuery(`SELECT * FROM Weave WHERE id = ?`, [weave_id]);

    if (result.length === 0) {
      return {
        statusCode: 506,
        body: { message: '위브를 찾을 수 없습니다.' },
      };
    }
  } catch (error) {
    console.error('Error uploading post:', error);
    return {
      statusCode: 502,
      body: { message: '데이터가 정상 처리되지 않았습니다. ' },
    };
  } finally {
    await closeConnection();
  }

  try {
    let query = `INSERT INTO Post 
    (user_id, privacy_id, weave_id, text_content, location, area_id) VALUES 
    (?, ?, ?, ?, ?, ?)`;
    let values = [user_id, privacy_id, weave_id, content, location, area_id];
    if (area_id == null) {
      query = `INSERT INTO Post
      (user_id, privacy_id, weave_id, text_content, location) VALUES
      (?, ?, ?, ?, ?)`;
      values = [user_id, privacy_id, weave_id, content, location];
    }
    if (location == null || area_id == null) {
      query = `INSERT INTO Post
      (user_id, privacy_id, weave_id, text_content) VALUES
      (?, ?, ?, ?)`;
      values = [user_id, privacy_id, weave_id, content];
    }

    let result = await executeQuery(query, values);

    const media_result = [];
    for ( const file of files) {
      query = `INSERT INTO Media (user_id, post_id, content_type, content_url) VALUES 
      (?, ?, ?, ?)`;
      values = [user_id, result.insertId, file.Type, 'https://weave-bucket.s3.ap-northeast-2.amazonaws.com/post/' + user_id + '/' + file.name];
      media_result.push(await executeQuery(query, values));
    }

    query = `UPDATE Post SET thumbnail_media_id = ? WHERE id = ?`
    values = [media_result[0].insertId, result.insertId];
    result = await executeQuery(query, values);

    return {
      statusCode: 200,
      body: { message: '게시물 등록 성공' },
    };
  } catch (error) {
    console.error('Error uploading post:', error);
    return {
      statusCode: 502,
      body: { message: '데이터가 정상 처리되지 않았습니다.' },
    };
  } finally {
    await closeConnection();
  }
};
