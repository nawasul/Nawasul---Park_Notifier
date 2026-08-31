from fastapi import APIRouter

router = APIRouter(prefix="/qr", tags=["qr"])


@router.get("/status")
async def qr_status():
    return {"status": "ok", "module": "qr"}
