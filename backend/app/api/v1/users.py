from fastapi import APIRouter

router = APIRouter(prefix="/users", tags=["users"])


@router.get("/status")
async def users_status():
    return {"status": "ok", "module": "users"}
