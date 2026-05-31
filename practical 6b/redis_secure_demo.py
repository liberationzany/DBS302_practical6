import redis


def create_redis_client():
    return redis.Redis(
        host="127.0.0.1",
        port=6380,
        username="app_user",
        password="appStrongPwd",
        ssl=True,
        ssl_ca_certs="./certs/redis/ca.crt",
        decode_responses=True,
    )


if __name__ == "__main__":
    r = create_redis_client()
    print("Connected as:", r.acl_whoami())
    r.set("session6b:python_demo", "hello from python practical 6b")
    print("Value:", r.get("session6b:python_demo"))
