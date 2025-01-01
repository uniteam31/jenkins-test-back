FROM node

RUN apt -yqq update \
    && apt -yqq install git curl nginx \
    && apt clean

# NGINX CONFIGURE
RUN rm /etc/nginx/sites-enabled/default
COPY nginx/default /etc/nginx/sites-enabled

# INSTALL YARN
RUN corepack enable
RUN yarn init -2

# CHECKOUT
ARG BRANCH=dev
RUN git clone https://github.com/uniteam31/jenkins-test-back.git
WORKDIR /jenkins-test
RUN git fetch --all
RUN git pull
RUN git checkout ${BRANCH}

# INSTALL DEPS
RUN yarn install
RUN yarn build

WORKDIR /jenkins-test/dist

CMD ["node", "main.js"]
