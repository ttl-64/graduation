FROM node:16.20.0-alpine3.18 as builder
WORKDIR /usr/src/app
COPY . .
ENV VUE_APP_API_URL=/
RUN npm install
RUN npm run build

FROM nginx:latest
WORKDIR /app
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
EXPOSE 80