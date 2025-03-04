import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { verifyAccessToken } from './jwt.mjs';


const s3Client = new S3Client({ region: 'ap-northeast-2' });

export async function handler(event, context) {
  const verifyed = verifyAccessToken(event);

  if (verifyed.code !== 1) {
      return {
          statusCode: verifyed.status,
          body: { message: verifyed.message },
      };
  }
  
  try {
    const { user_id, files } = event.body;
    const response = [];

    if (!user_id || !files) {
      return {
        statusCode: 400,
        body: 'No user_id or filename provided'
      };
    }


    for ( const file of files ) {
      const { filename, fileType } = file;

      if (!filename) {
        continue; // throw Error('filename missing');
      }

      const objectKey = `post/${user_id}/${filename}`;

      const command = new PutObjectCommand({
        Bucket: 'weave-bucket',
        Key: objectKey,
        ContentType: fileType,
        ACL: 'public-read'
      });

      const expiresIn = 300;
      const presignedUrl = await getSignedUrl(s3Client, command, { expiresIn });

      response.push({
        filename,
        presignedUrl
      });
    }

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
