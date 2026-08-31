from fastapi import APIRouter

router = APIRouter(prefix="/vehicles", tags=["vehicles"])


@router.get("/status")
async def vehicles_status():
    return {"status": "ok", "module": "vehicles"}
