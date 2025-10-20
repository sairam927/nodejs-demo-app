FROM ghcr.io/library/node:18


WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production || npm install

COPY . .

EXPOSE 3000
CMD ["npm", "start"]

