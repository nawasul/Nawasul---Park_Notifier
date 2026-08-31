from fastapi import APIRouter

router = APIRouter(prefix="/notifications", tags=["notifications"])


@router.get("/status")
async def notifications_status():
    return {"status": "ok", "module": "notifications"}
