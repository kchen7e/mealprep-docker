FROM node:alpine
WORKDIR /app
COPY ./mealprep-frontend/ ./
RUN npm install -g npm && npm install
ENTRYPOINT ["npm", "run", "start"]