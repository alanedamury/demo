FROM golang:1.15 as builder

ENV APP_USER app
ENV APP_HOME /go/src/postgresql-go

RUN groupadd $APP_USER && useradd -m -g $APP_USER -l $APP_USER
RUN mkdir -p $APP_HOME && chown -R $APP_USER:$APP_USER $APP_HOME
WORKDIR $APP_HOME
USER $APP_USER
COPY . .
RUN go mod init
RUN go mod tidy
RUN go build -o postgresql-go -mod=mod

FROM golang:1.15

ENV APP_USER app
ENV APP_HOME /go/src/postgresql-go

RUN groupadd $APP_USER && useradd -m -g $APP_USER -l $APP_USER
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY --chown=0:0 --from=builder $APP_HOME/postgresql-go $APP_HOME
COPY --chown=0:0 --from=builder $APP_HOME/static  $APP_HOME/static/

EXPOSE 8080
USER $APP_USER
CMD ["./postgresql-go"]
