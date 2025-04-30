import jwt from 'jsonwebtoken';
import crypto from 'crypto';


const config = {
  ACCESS_TOKEN_SECRET: process.env.ACCESS_TOKEN_SECRET,
  REFRESH_TOKEN_SECRET: process.env.REFRESH_TOKEN_SECRET,
};

export function createAccessToken(payload) {
  return jwt.sign(payload, config.ACCESS_TOKEN_SECRET, { expiresIn: '10m' });
};

// 리프레시 토큰 생성 함수
export function createRefreshToken(payload) {
  return jwt.sign(payload, config.REFRESH_TOKEN_SECRET, { expiresIn: '3d' });
};

export function verifyAccessToken(event) {
  // 0 : access token 만료, 1 : 검증, -1 : userid 불일치, -2 : 토큰 없음
  try {
    const accessToken = event.headers.accesstoken;
    const user_id = event.body.user_id;

    if (!accessToken) {
      return {
        code: -2,
        status: 405,
        message: "유효하지 않은 토큰입니다."
      };
    }

    const decoded = jwt.verify(accessToken, config.ACCESS_TOKEN_SECRET);
    event.body.user_id = decoded.user_id;
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
    const refreshToken = event.headers.refreshtoken;
    const user_id = event.body.user_id;

    if (!refreshToken) {
      return {
        code: -2,
        status: 405,
        message: "유효하지 않은 토큰입니다."
      };
    }

    const decoded = jwt.verify(refreshToken, config.REFRESH_TOKEN_SECRET);
    event.body.user_id = decoded.user_id;
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