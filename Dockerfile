FROM node:11.3.0-stretch-slim
COPY . /app
WORKDIR app
RUN npm install
RUN npm run-script build

FROM node:11.3.0-stretch-slim
COPY --from=0 /app/dist /app
WORKDIR app
RUN npm install --only=prod
CMD ["node", "main.js"]

