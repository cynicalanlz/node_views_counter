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
RUN apt-get update
RUN groupadd -r redis && useradd -r -g redis redis
RUN mkdir /data && chown redis:redis /data
RUN apt-get install -y redis-server supervisor
RUN which node
RUN node --version
VOLUME /data
WORKDIR /app
RUN npm install
EXPOSE 8081
#CMD ["sh", "start.sh"]
CMD ["redis-server", "--port 6380"]