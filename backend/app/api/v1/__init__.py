from fastapi import APIRouter

from app.api.v1 import (
    admin,
    auth,
    notifications,
    qr,
    subscriptions,
    users,
    vehicles,
)

api_router = APIRouter(prefix="/api/v1")
api_router.include_router(auth.router)
api_router.include_router(users.router)
api_router.include_router(vehicles.router)
api_router.include_router(qr.router)
api_router.include_router(subscriptions.router)
api_router.include_router(notifications.router)
api_router.include_router(admin.router)
