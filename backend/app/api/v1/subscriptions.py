from fastapi import APIRouter

router = APIRouter(prefix="/subscriptions", tags=["subscriptions"])


@router.get("/status")
async def subscriptions_status():
    return {"status": "ok", "module": "subscriptions"}
