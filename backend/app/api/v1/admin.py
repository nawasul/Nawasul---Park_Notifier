from fastapi import APIRouter

router = APIRouter(prefix="/admin", tags=["admin"])


@router.get("/status")
async def admin_status():
    return {"status": "ok", "module": "admin"}
