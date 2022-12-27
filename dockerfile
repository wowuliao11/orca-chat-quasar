# develop stage
FROM node:16.18.1-alpine as development

WORKDIR /app

COPY package*.json ./

RUN yarn set version latest

RUN yarn global add @quasar/cli

COPY . .

COPY .env.production .env

# build stage
FROM development as build-stage

RUN yarn set version latest

RUN yarn

RUN quasar build

# production stage
FROM nginx:1.17.5-alpine as production-stage

COPY --from=build-stage /app/dist/spa /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
