import jwt from 'jsonwebtoken';
import crypto from 'crypto';

const config = {
  ACCESS_TOKEN_SECRET: process.env.ACCESS_TOKEN_SECRET,
  REFRESH_TOKEN_SECRET: process.env.REFRESH_TOKEN_SECRET,
};

export function createAccessToken(payload) {
  const accessPayload = { ...payload };
  accessPayload.nonce = crypto.randomBytes(16).toString('hex');

  return jwt.sign(accessPayload, config.ACCESS_TOKEN_SECRET, { expiresIn: '10m' });
};

// 리프레시 토큰 생성 함수
export function createRefreshToken(payload) {
  const refreshPayload = { ...payload };
  refreshPayload.nonce = crypto.randomBytes(16).toString('hex');

  return jwt.sign(refreshPayload, config.REFRESH_TOKEN_SECRET, { expiresIn: '3d' });
};

export function verifyAccessToken(event) {
  // 0 : access token 만료, 1 : 검증, -1 : userid 불일치, -2 : 토큰 없음
  try {
    const accessToken = event.headers.accessToken;
    const userId = event.body.user_id;

    if (!accessToken) {
      return {
        code: -2,
        status: 405,
        message: "유효하지 않은 토큰입니다."
      };
    }

    const decoded = jwt.verify(accessToken, config.ACCESS_TOKEN_SECRET);

    if (Number(decoded.user_id) !== Number(user_id)) {

      return {
        code: -1,
        status: 404,
        message: "접근 권한이 없습니다."
      };
    }

    return { code: 1, payload: decoded  };
  } catch (error) {
    return {
      code: 0,
      status: 401,
      message: "access token 만료"
    };
  }
}

export function verifyRefreshToken(event) {
  // 0 : access token 만료, 1 : 검증, -1 : userid 불일치, -2 : 토큰 없음
  try {
    const refreshToken = event.headers.refreshToken;
    const userId = event.body.user_id;

    if (!refreshToken) {
      return {
        code: -2,
        status: 405,
        message: "유효하지 않은 토큰입니다."
      };
    }

    const decoded = jwt.verify(refreshToken, config.REFRESH_TOKEN_SECRET);

    if (Number(decoded.user_id) !== Number(user_id)) {

      return {
        code: -1,
        status: 404,
        message: "접근 권한이 없습니다."
      };
    }

    return { code: 1, payload: decoded };
  } catch (error) {
    return {
      code: 0,
      status: 403,
      message: "refresh token 만료"
    };
  }
};