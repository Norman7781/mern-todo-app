# ---------- Frontend Build ----------
FROM node:22-alpine AS frontend

WORKDIR /app/frontend

COPY TODO/todo_frontend/package*.json ./
RUN npm install

COPY TODO/todo_frontend .
RUN npm run build


# ---------- Backend ----------
FROM node:22-alpine

WORKDIR /app/backend

COPY TODO/todo_backend/package*.json ./
RUN npm install

COPY TODO/todo_backend .

# Copy frontend build into backend
RUN mkdir -p ./static
COPY --from=frontend /app/frontend/build ./static/build

EXPOSE 5000

CMD ["node", "server.js"]