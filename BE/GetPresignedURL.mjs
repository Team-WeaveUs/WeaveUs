import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { verifyAccessToken } from './jwt.mjs';


const s3Client = new S3Client({ region: 'ap-northeast-2' });

export async function handler(event, context) {
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
  
  try {
    // event.body 내에 user_id, filename, fileType이 있다고 가정
    const { user_id, files } = event.body;
    const response = [];

    // user_id, filename 값이 없으면 오류 반환
    if (!user_id || !files) {
      return {
        statusCode: 400,
        body: 'No user_id or filename provided'
      };
    }


    for ( const file of files ) {
      const { filename, fileType } = file;

      if (!filename) {
        // 파일마다 에러 처리가 필요하다면
        continue; // 또는 throw Error('filename missing');
      }

      // post/user_id/ 경로 하위에 저장 (S3에서는 별도 폴더 생성이 필요 없음)
      const objectKey = `post/${user_id}/${filename}`;

      // PUT presigned URL 생성
      const command = new PutObjectCommand({
        Bucket: 'weave-bucket',
        Key: objectKey,
        ContentType: fileType,
        ACL: 'public-read'
      });

      const expiresIn = 300; // 360초 (6분) 유효기간 예시
      const presignedUrl = await getSignedUrl(s3Client, command, { expiresIn });

      response.push({
        filename,
        presignedUrl
      });
    }

    // JSON.stringify 사용 금지 조건 -> 문자열만 반환
    return {
      statusCode: 200,
      body: response
    };
  } catch (error) {
    console.error('Error generating presigned URL:', error);
    return {
      statusCode: 500,
      body: {
        message: 'Failed to generate presigned URL'
      }
    };
  }
}
