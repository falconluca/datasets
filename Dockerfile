FROM nginx

WORKDIR /app
COPY ./ /app

# 执行安装脚本
RUN sed -i 's!http://dl-cdn.alpinelinux.org/!https://mirrors.ustc.edu.cn/!g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y jq

RUN chmod +x /app/main.sh
RUN ./main.sh

COPY dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf

# TODO 启动定时脚本

EXPOSE 80
