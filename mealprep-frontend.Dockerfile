FROM nginx:alpine
ARG FRONTEND_TAR=MealPrep-frontend-0.4.0.tar.gz
COPY ${FRONTEND_TAR} /tmp/
RUN tar -xzf /tmp/${FRONTEND_TAR} -C /usr/share/nginx/html && rm /tmp/${FRONTEND_TAR}
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
