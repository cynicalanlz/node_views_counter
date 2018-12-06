FROM node:10.14.1-jessie-slim
COPY . /app
WORKDIR /app
RUN npm install
RUN npm run-script build

FROM node:10.14.1-jessie-slim
COPY --from=0 /app/dist/main.js /app/app.js
COPY --from=0 /app/package.json /app/package.json
COPY --from=0 /app/start.sh /app/start.sh
COPY --from=0 /app/supervisor.conf /app/supervisor.conf
RUN export NODE_ENV=production
RUN groupadd -r redis && useradd -r -g redis redis
RUN mkdir /data && chown redis:redis /data
RUN apt-get update
RUN apt-get install -y redis-server supervisor
RUN systemctl enable redis-server
VOLUME /data
WORKDIR /app
RUN npm install
EXPOSE 8081
CMD ["node app.js"]
RUN echo "Still here"