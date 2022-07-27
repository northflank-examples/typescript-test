FROM node:16-alpine AS builder

RUN mkdir -p /app
WORKDIR /app

COPY package.json  .
COPY yarn.lock .
RUN yarn install

COPY . .

RUN yarn run build

FROM node:16-alpine

COPY --from=builder /app/dist dist
COPY --from=builder /app/package.json package.json
COPY --from=builder /app/yarn.lock yarn.lock

RUN yarn install --production

CMD [ "yarn", "run", "start" ]
