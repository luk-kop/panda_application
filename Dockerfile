FROM busybox:latest

CMD ["+%s"]
ENTRYPOINT ["date"]