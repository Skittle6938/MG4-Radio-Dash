.class Lcom/saicmotor/radio/service/RadioService$6;
.super Ljava/lang/Object;
.source "RadioService.java"

# interfaces
.implements Lcom/saicmotor/radio/listener/RadioBinderListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/saicmotor/radio/service/RadioService;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/saicmotor/radio/service/RadioService;


# direct methods
.method constructor <init>(Lcom/saicmotor/radio/service/RadioService;)V
    .locals 0

    .line 1137
    iput-object p1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public addDabTunerCallback(Lcom/android/car/radio/service/IDabCallback;)V
    .locals 2

    .line 1883
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    if-nez v0, :cond_0

    .line 1884
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object p1

    const-string v0, "addabTunerCallback() drm is not initialize"

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->e(Ljava/lang/String;)V

    return-void

    .line 1887
    :cond_0
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "addDabTunerCallback()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    if-nez p1, :cond_1

    return-void

    .line 1891
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$4000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v0

    monitor-enter v0

    .line 1892
    :try_start_0
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$4000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v1

    invoke-virtual {v1, p1}, Landroid/os/RemoteCallbackList;->register(Landroid/os/IInterface;)Z

    .line 1893
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method public addRadioTunerCallback(Lcom/android/car/radio/service/IRadioCallback;)V
    .locals 3

    .line 1422
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "addRadioTunerCallback():"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    if-nez p1, :cond_0

    return-void

    .line 1426
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v0

    monitor-enter v0

    .line 1427
    :try_start_0
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v1

    invoke-virtual {v1, p1}, Landroid/os/RemoteCallbackList;->register(Landroid/os/IInterface;)Z

    .line 1428
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method public cancel()V
    .locals 2

    .line 1245
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "cancel()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1246
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 1247
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->cancel()V

    :cond_0
    return-void
.end method

.method public cancelSeekingOrScanning()V
    .locals 2

    .line 1261
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "cancelSeekingOrScanning()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1262
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 1263
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->cancel()V

    .line 1266
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getScanStatus()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 1267
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1800(Lcom/saicmotor/radio/service/RadioService;)V

    .line 1269
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getSearchStatus()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 1270
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$700(Lcom/saicmotor/radio/service/RadioService;)V

    :cond_2
    return-void
.end method

.method public dabClose()V
    .locals 1

    .line 1913
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 1914
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/DabRadioStationManager;->closeDab()V

    :cond_0
    return-void
.end method

.method public dabScan(I)V
    .locals 1

    .line 1939
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 1940
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/manager/DabRadioStationManager;->dabScan(I)V

    :cond_0
    return-void
.end method

.method public dabServiceFollow(Z)V
    .locals 0

    return-void
.end method

.method public dabStep(I)V
    .locals 1

    .line 1932
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 1933
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/manager/DabRadioStationManager;->dabStep(I)V

    :cond_0
    return-void
.end method

.method public dabSwitchSource(I)V
    .locals 1

    .line 1920
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 1921
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/manager/DabRadioStationManager;->dabSwitchSource(I)V

    :cond_0
    return-void
.end method

.method public dabTune(Lcom/android/car/radio/service/RadioDabStation;)V
    .locals 1

    .line 1927
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/service/RadioService;->tuneRadioDab(Lcom/android/car/radio/service/RadioDabStation;)V

    return-void
.end method

.method public getCarplayAAPScreenShowingStatus()Z
    .locals 1

    .line 1642
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3800(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v0

    return v0
.end method

.method public getCurrentRadioStation()Lcom/android/car/radio/service/RadioStation;
    .locals 2

    .line 1446
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "getCurrentRadioStation()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1448
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3200(Lcom/saicmotor/radio/service/RadioService;)Lcom/android/car/radio/service/RadioStation;

    move-result-object v0

    return-object v0
.end method

.method public getCurrentRadioStationForEol()Lcom/android/car/radio/service/RadioStation;
    .locals 5

    .line 1453
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "getCurrentRadioStationForEol()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1455
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v1

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$3400(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v2

    invoke-static {v0, v1, v2}, Lcom/saicmotor/radio/service/RadioService;->access$3500(Lcom/saicmotor/radio/service/RadioService;II)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1456
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 1457
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v1

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$3300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v2

    invoke-virtual {v1, v2}, Lcom/saicmotor/radio/model/RadioStorage;->getStoredRadioChannel(I)I

    move-result v1

    invoke-static {v0, v1}, Lcom/saicmotor/radio/service/RadioService;->access$3402(Lcom/saicmotor/radio/service/RadioService;I)I

    .line 1462
    :cond_0
    new-instance v0, Lcom/android/car/radio/service/RadioStation;

    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$3400(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v1

    const/4 v2, 0x0

    iget-object v3, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    .line 1463
    invoke-static {v3}, Lcom/saicmotor/radio/service/RadioService;->access$3300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v3

    iget-object v4, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v4}, Lcom/saicmotor/radio/service/RadioService;->access$3600(Lcom/saicmotor/radio/service/RadioService;)Lcom/android/car/radio/service/RadioRds;

    move-result-object v4

    invoke-direct {v0, v1, v2, v3, v4}, Lcom/android/car/radio/service/RadioStation;-><init>(IIILcom/android/car/radio/service/RadioRds;)V

    return-object v0
.end method

.method public getpara(II)V
    .locals 3

    .line 1490
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "getpara() address: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " length: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1491
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-nez v0, :cond_0

    return-void

    .line 1494
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getRadioTuner()Landroid/hardware/radio/RadioTuner;

    move-result-object v0

    if-nez v0, :cond_1

    .line 1495
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v1

    invoke-static {v0, v1}, Lcom/saicmotor/radio/service/RadioService;->access$2800(Lcom/saicmotor/radio/service/RadioService;I)I

    move-result v0

    const/high16 v1, -0x80000000

    if-ne v0, v1, :cond_1

    return-void

    .line 1500
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0, p1, p2}, Lcom/saicmotor/radio/manager/RadioStationManager;->getpara(II)V

    return-void
.end method

.method public hasDualTuners()Z
    .locals 2

    .line 1484
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "hasDualTuners()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1485
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->hasDualTuners()Z

    move-result v0

    return v0
.end method

.method public hasFocus()Z
    .locals 2

    .line 1474
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "hasFocus()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1475
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$800(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$900(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    return v0

    :cond_0
    const/4 v0, 0x0

    return v0
.end method

.method public isCurrentChannelFavorite()Z
    .locals 5

    .line 1589
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "isCurrentChannelFavorite()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1591
    new-instance v0, Lcom/android/car/radio/service/RadioStation;

    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$500(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v1

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    .line 1592
    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v2

    const/4 v3, 0x0

    const/4 v4, 0x0

    invoke-direct {v0, v1, v3, v2, v4}, Lcom/android/car/radio/service/RadioStation;-><init>(IIILcom/android/car/radio/service/RadioRds;)V

    .line 1593
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v1

    if-eqz v1, :cond_0

    .line 1594
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/saicmotor/radio/model/RadioStorage;->isFavorite(Lcom/android/car/radio/service/RadioStation;)Z

    move-result v0

    return v0

    :cond_0
    return v3
.end method

.method public isFavoriteListEmpty()Z
    .locals 4

    .line 1602
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "isFavoriteListEmpty()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1606
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-eqz v0, :cond_0

    .line 1607
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/model/RadioStorage;->getFavoriteForBand(I)Ljava/util/List;

    move-result-object v0

    .line 1608
    iget-object v3, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v3}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v3

    invoke-virtual {v3, v1}, Lcom/saicmotor/radio/model/RadioStorage;->getFavoriteForBand(I)Ljava/util/List;

    move-result-object v3

    .line 1610
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    if-gtz v0, :cond_1

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v0

    if-lez v0, :cond_0

    goto :goto_0

    :cond_0
    move v1, v2

    .line 1615
    :cond_1
    :goto_0
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "isFavoriteListEmpty() result="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return v1
.end method

.method public isInitialized()Z
    .locals 2

    .line 1468
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "isInitialized()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1469
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3700(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v0

    return v0
.end method

.method public isMute()Z
    .locals 1

    .line 1305
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->isMuted()Z

    move-result v0

    return v0
.end method

.method public isMuted()Z
    .locals 3

    .line 1371
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$800(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$900(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 1375
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2600(Lcom/saicmotor/radio/service/RadioService;)Landroid/media/AudioManager;

    move-result-object v0

    if-nez v0, :cond_1

    .line 1376
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v2, "isMuted() called, but not connected to CarAudioManager"

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return v1

    .line 1379
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->isMuted()Z

    move-result v0

    return v0

    :cond_2
    :goto_0
    return v1
.end method

.method public mute(Z)Z
    .locals 5

    .line 1310
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "mute() \uff1a "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, "  mHasAudioFocusTransient = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$900(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, "   mHasAudioFocus = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    .line 1311
    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$800(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 1310
    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1313
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2600(Lcom/saicmotor/radio/service/RadioService;)Landroid/media/AudioManager;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_6

    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-nez v0, :cond_0

    goto/16 :goto_3

    .line 1320
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$900(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 1321
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object p1

    const-string v0, "mute() called, but radio does not currently have audio focus; ignoring."

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    const/4 p1, 0x1

    return p1

    .line 1325
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$800(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v0

    if-nez v0, :cond_2

    .line 1326
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object p1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "mHasAudioFocus = "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$800(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1328
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$2700(Lcom/saicmotor/radio/service/RadioService;)I

    move p1, v1

    .line 1330
    :cond_2
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getRadioTuner()Landroid/hardware/radio/RadioTuner;

    move-result-object v0

    if-nez v0, :cond_3

    .line 1331
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v2

    invoke-static {v0, v2}, Lcom/saicmotor/radio/service/RadioService;->access$2800(Lcom/saicmotor/radio/service/RadioService;I)I

    move-result v0

    const/high16 v2, -0x80000000

    if-ne v0, v2, :cond_3

    return v1

    .line 1336
    :cond_3
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0, p1}, Lcom/saicmotor/radio/service/RadioService;->access$2902(Lcom/saicmotor/radio/service/RadioService;Z)Z

    .line 1337
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/manager/RadioStationManager;->mute(Z)Z

    move-result p1

    .line 1338
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v0

    monitor-enter v0

    .line 1339
    :try_start_0
    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v2

    invoke-virtual {v2}, Landroid/os/RemoteCallbackList;->beginBroadcast()I

    move-result v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :goto_0
    if-ge v1, v2, :cond_4

    .line 1342
    :try_start_1
    iget-object v3, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v3}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v3

    invoke-virtual {v3, v1}, Landroid/os/RemoteCallbackList;->getBroadcastItem(I)Landroid/os/IInterface;

    move-result-object v3

    check-cast v3, Lcom/android/car/radio/service/IRadioCallback;

    invoke-interface {v3, p1}, Lcom/android/car/radio/service/IRadioCallback;->onRadioMuteChanged(Z)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_1

    :catch_0
    move-exception v3

    .line 1344
    :try_start_2
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v4

    invoke-virtual {v3}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 1347
    :cond_4
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v1

    invoke-virtual {v1}, Landroid/os/RemoteCallbackList;->finishBroadcast()V

    .line 1348
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-eqz p1, :cond_5

    .line 1350
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3000(Lcom/saicmotor/radio/service/RadioService;)V

    goto :goto_2

    .line 1352
    :cond_5
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3100(Lcom/saicmotor/radio/service/RadioService;)V

    :goto_2
    return p1

    :catchall_0
    move-exception p1

    .line 1348
    :try_start_3
    monitor-exit v0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    throw p1

    .line 1314
    :cond_6
    :goto_3
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object p1

    const-string v0, "mute() called, but not connected to CarAudioManager"

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return v1
.end method

.method public onMediaSessionFastForward()Z
    .locals 5

    .line 1772
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "onMediaSessionFastForward()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1773
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3900(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/service/RadioManagerBinder;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 1774
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v2, "mSessionCallback -> onMediaSessionFastForward() Binder is NULL."

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return v1

    .line 1778
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v0

    const/4 v2, 0x1

    if-eqz v0, :cond_3

    if-eq v0, v2, :cond_3

    const/4 v3, 0x4

    if-eq v0, v3, :cond_1

    .line 1818
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v2, "mSessionCallback -> onMediaSessionFastForward::mCurrentRadioBand Error."

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    goto/16 :goto_0

    .line 1803
    :cond_1
    :try_start_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    if-eqz v0, :cond_6

    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_6

    .line 1804
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/model/RadioStorage;->getDabFastForwardNextValidStation()Lcom/android/car/radio/service/RadioDabStation;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 1806
    iget-object v3, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-virtual {v3, v0}, Lcom/saicmotor/radio/service/RadioService;->tuneRadioDab(Lcom/android/car/radio/service/RadioDabStation;)V

    return v2

    .line 1809
    :cond_2
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v2, "onMediaSessionFastForward  getDabFastForwardNextValidStation = null"

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return v1

    :catch_0
    move-exception v0

    .line 1813
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v2

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "mSessionCallback onMediaSessionFastForward; Failed: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    goto :goto_0

    .line 1781
    :cond_3
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-nez v0, :cond_4

    .line 1782
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v2, "mSessionCallback -> mRadioStationManager is NULL."

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return v1

    .line 1786
    :cond_4
    :try_start_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    if-eqz v0, :cond_6

    .line 1787
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    iget-object v3, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v3}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v3

    iget-object v4, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v4}, Lcom/saicmotor/radio/service/RadioService;->access$3200(Lcom/saicmotor/radio/service/RadioService;)Lcom/android/car/radio/service/RadioStation;

    move-result-object v4

    invoke-virtual {v0, v3, v4}, Lcom/saicmotor/radio/model/RadioStorage;->getFastForwardNextValidStation(ILcom/android/car/radio/service/RadioStation;)Lcom/android/car/radio/service/RadioStation;

    move-result-object v0

    if-eqz v0, :cond_5

    .line 1789
    iget-object v3, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-virtual {v3, v0}, Lcom/saicmotor/radio/service/RadioService;->tuneRadioTune(Lcom/android/car/radio/service/RadioStation;)V

    return v2

    .line 1792
    :cond_5
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v2, "onMediaSessionFastForward getFastForwardNextValidStation = null"

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    return v1

    :catch_1
    move-exception v0

    .line 1797
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v2

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "mSessionCallback onMediaSessionFastForward(); Failed: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    :cond_6
    :goto_0
    return v1
.end method

.method public onMediaSessionPause()V
    .locals 4

    .line 1680
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "onMediaSessionPause()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1681
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3900(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/service/RadioManagerBinder;

    move-result-object v0

    if-nez v0, :cond_0

    .line 1682
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "mSessionCallback -> onMediaSessionPause() Binder is NULL."

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void

    .line 1685
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v0

    const/4 v1, 0x1

    if-eqz v0, :cond_1

    if-eq v0, v1, :cond_1

    const/4 v2, 0x4

    if-eq v0, v2, :cond_1

    .line 1697
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "mSessionCallback -> onPause::mCurrentRadioBand Error."

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    goto :goto_0

    .line 1691
    :cond_1
    :try_start_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3900(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/service/RadioManagerBinder;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/service/RadioManagerBinder;->mute(Z)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 1693
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "mSessionCallback -> onPause::tuneStop(true); Failed: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public onMediaSessionPlay()V
    .locals 3

    # Radio Dash : une lecture lancée par le volant ou l'accueil compte pour la reprise auto
    const/4 v0, 0x1

    invoke-static {p0, v0}, Lapp/mg4dash/radiodash/Favorites;->wasPlaying(Ljava/lang/Object;Z)V

    .line 1647
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "onMediaSessionPlay()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1648
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3900(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/service/RadioManagerBinder;

    move-result-object v0

    if-nez v0, :cond_0

    .line 1649
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "mSessionCallback -> onMediaSessionPlay() Binder is NULL."

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void

    .line 1652
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    const/4 v2, 0x1

    if-eq v0, v2, :cond_2

    const/4 v2, 0x4

    if-eq v0, v2, :cond_1

    .line 1672
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "mSessionCallback -> onPlay::mCurrentRadioBand Error."

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    goto :goto_2

    .line 1665
    :cond_1
    :try_start_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3900(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/service/RadioManagerBinder;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/service/RadioManagerBinder;->mute(Z)Z
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 1667
    invoke-virtual {v0}, Landroid/os/RemoteException;->printStackTrace()V

    .line 1669
    :goto_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2200(Lcom/saicmotor/radio/service/RadioService;)V

    goto :goto_2

    .line 1656
    :cond_2
    :try_start_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3900(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/service/RadioManagerBinder;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/service/RadioManagerBinder;->mute(Z)Z
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_1

    :catch_1
    move-exception v0

    .line 1658
    invoke-virtual {v0}, Landroid/os/RemoteException;->printStackTrace()V

    .line 1660
    :goto_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2100(Lcom/saicmotor/radio/service/RadioService;)V

    :goto_2
    return-void
.end method

.method public onMediaSessionRewind()Z
    .locals 5

    .line 1827
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3900(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/service/RadioManagerBinder;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 1828
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v2, "mSessionCallback -> onMediaSessionRewind() Binder is NULL."

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return v1

    .line 1832
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v0

    const/4 v2, 0x1

    if-eqz v0, :cond_3

    if-eq v0, v2, :cond_3

    const/4 v3, 0x4

    if-eq v0, v3, :cond_1

    .line 1862
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v2, "mSessionCallback -> onMediaSessionRewind::mCurrentRadioBand Error."

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    goto/16 :goto_0

    .line 1848
    :cond_1
    :try_start_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    if-eqz v0, :cond_5

    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_5

    .line 1849
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/model/RadioStorage;->getDabRewindPreValidStation()Lcom/android/car/radio/service/RadioDabStation;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 1851
    iget-object v3, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-virtual {v3, v0}, Lcom/saicmotor/radio/service/RadioService;->tuneRadioDab(Lcom/android/car/radio/service/RadioDabStation;)V

    return v2

    .line 1854
    :cond_2
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v2, "onMediaSessionRewind  getDabRewindPreValidStation = null"

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return v1

    :catch_0
    move-exception v0

    .line 1858
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v2

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "mSessionCallback onMediaSessionRewind; Failed: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    goto :goto_0

    .line 1835
    :cond_3
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    if-eqz v0, :cond_5

    .line 1836
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    iget-object v3, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v3}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v3

    iget-object v4, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v4}, Lcom/saicmotor/radio/service/RadioService;->access$3200(Lcom/saicmotor/radio/service/RadioService;)Lcom/android/car/radio/service/RadioStation;

    move-result-object v4

    invoke-virtual {v0, v3, v4}, Lcom/saicmotor/radio/model/RadioStorage;->getRewindPreValidStation(ILcom/android/car/radio/service/RadioStation;)Lcom/android/car/radio/service/RadioStation;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 1838
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-virtual {v1, v0}, Lcom/saicmotor/radio/service/RadioService;->tuneRadioTune(Lcom/android/car/radio/service/RadioStation;)V

    return v2

    .line 1841
    :cond_4
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v2, "onMediaSessionRewind  getRewindPreValidStation = null"

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    :cond_5
    :goto_0
    return v1
.end method

.method public onMediaSessionSkipToNext()V
    .locals 4

    .line 1705
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "onMediaSessionSkipToNext()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1706
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3900(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/service/RadioManagerBinder;

    move-result-object v0

    if-nez v0, :cond_0

    .line 1707
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "mSessionCallback -> onMediaSessionSkipToNext() Binder is NULL."

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void

    .line 1711
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v0

    if-eqz v0, :cond_3

    const/4 v1, 0x1

    if-eq v0, v1, :cond_3

    const/4 v1, 0x4

    if-eq v0, v1, :cond_1

    .line 1731
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "mSessionCallback -> onSkipToNext::mCurrentRadioBand Error."

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    goto :goto_0

    .line 1718
    :cond_1
    :try_start_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    if-eqz v0, :cond_4

    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 1719
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lapp/mg4dash/radiodash/Favorites;->nextDab(Ljava/lang/Object;Z)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/car/radio/service/RadioDabStation;


    if-nez v0, :cond_2

    return-void

    .line 1723
    :cond_2
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-virtual {v1, v0}, Lcom/saicmotor/radio/service/RadioService;->tuneRadioDab(Lcom/android/car/radio/service/RadioDabStation;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 1726
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "mSessionCallback onSkipToNext::seekForward(); Failed: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    goto :goto_0

    .line 1714
    :cond_3
    const/4 v0, 0x1

    invoke-static {p0, v0}, Lapp/mg4dash/radiodash/Favorites;->skipFm(Ljava/lang/Object;Z)Z

    move-result v0

    if-nez v0, :rd_skip_fwd

    invoke-virtual {p0}, Lcom/saicmotor/radio/service/RadioService$6;->seekForward()V

    :rd_skip_fwd

    :cond_4
    :goto_0
    return-void
.end method

.method public onMediaSessionSkipToPrevious()V
    .locals 4

    .line 1739
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "onMediaSessionSkipToPrevious()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1740
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$3900(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/service/RadioManagerBinder;

    move-result-object v0

    if-nez v0, :cond_0

    .line 1741
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "mSessionCallback -> onMediaSessionSkipToPrevious() Binder is NULL."

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void

    .line 1745
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v0

    if-eqz v0, :cond_3

    const/4 v1, 0x1

    if-eq v0, v1, :cond_3

    const/4 v1, 0x4

    if-eq v0, v1, :cond_1

    .line 1764
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "mSessionCallback -> onSkipToPrevious::mCurrentRadioBand Error."

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    goto :goto_0

    .line 1752
    :cond_1
    :try_start_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    if-eqz v0, :cond_4

    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 1753
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lapp/mg4dash/radiodash/Favorites;->nextDab(Ljava/lang/Object;Z)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/car/radio/service/RadioDabStation;


    if-nez v0, :cond_2

    return-void

    .line 1757
    :cond_2
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-virtual {v1, v0}, Lcom/saicmotor/radio/service/RadioService;->tuneRadioDab(Lcom/android/car/radio/service/RadioDabStation;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 1760
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "mSessionCallback onSkipToNext::seekForward(); Failed: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    goto :goto_0

    .line 1748
    :cond_3
    const/4 v0, 0x0

    invoke-static {p0, v0}, Lapp/mg4dash/radiodash/Favorites;->skipFm(Ljava/lang/Object;Z)Z

    move-result v0

    if-nez v0, :rd_skip_back

    invoke-virtual {p0}, Lcom/saicmotor/radio/service/RadioService$6;->seekBackward()V

    :rd_skip_back

    :cond_4
    :goto_0
    return-void
.end method

.method public openRadioBand(I)I
    .locals 3

    .line 1384
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "openRadioBand() for band: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    const/high16 v0, -0x80000000

    if-eqz p1, :cond_5

    const/4 v1, 0x1

    if-eq p1, v1, :cond_5

    const/4 v2, 0x4

    if-eq p1, v2, :cond_0

    return v0

    .line 1401
    :cond_0
    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v2

    if-nez v2, :cond_1

    .line 1402
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object p1

    const-string v1, "openRadioBand() dab is not initialize"

    invoke-virtual {p1, v1}, Lcom/saicmotor/radio/utils/log/Logger;->e(Ljava/lang/String;)V

    return v0

    .line 1405
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v0

    if-ne v0, v1, :cond_3

    .line 1406
    :cond_2
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 1407
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->closeTunerFmAm()V

    .line 1411
    :cond_3
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 1412
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/model/RadioStorage;->storeRadioBand(I)V

    .line 1414
    :cond_4
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0, p1}, Lcom/saicmotor/radio/service/RadioService;->access$2800(Lcom/saicmotor/radio/service/RadioService;I)I

    move-result p1

    return p1

    .line 1390
    :cond_5
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v1

    if-eqz v1, :cond_6

    .line 1391
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v1

    invoke-virtual {v1, p1}, Lcom/saicmotor/radio/model/RadioStorage;->storeRadioBand(I)V

    .line 1394
    :cond_6
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v1

    if-eqz v1, :cond_7

    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v1

    invoke-virtual {v1}, Lcom/saicmotor/radio/manager/RadioStationManager;->checkStatusSearchAndScan()Z

    move-result v1

    if-nez v1, :cond_7

    .line 1395
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0, p1}, Lcom/saicmotor/radio/service/RadioService;->access$2800(Lcom/saicmotor/radio/service/RadioService;I)I

    move-result p1

    return p1

    :cond_7
    return v0
.end method

.method public playFavoriteList()V
    .locals 6

    .line 1535
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "playFavoriteList()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1536
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v0

    monitor-enter v0

    .line 1537
    :try_start_0
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v1

    invoke-virtual {v1}, Landroid/os/RemoteCallbackList;->beginBroadcast()I

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v2, 0x0

    move v3, v2

    :goto_0
    if-ge v3, v1, :cond_0

    .line 1540
    :try_start_1
    iget-object v4, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v4}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v4

    invoke-virtual {v4, v3}, Landroid/os/RemoteCallbackList;->getBroadcastItem(I)Landroid/os/IInterface;

    move-result-object v4

    check-cast v4, Lcom/android/car/radio/service/IRadioCallback;

    invoke-interface {v4}, Lcom/android/car/radio/service/IRadioCallback;->onPlayFavoriteListRequest()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_1

    :catch_0
    move-exception v4

    .line 1542
    :try_start_2
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v5

    invoke-virtual {v4}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v5, v4}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 1545
    :cond_0
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v1

    invoke-virtual {v1}, Landroid/os/RemoteCallbackList;->finishBroadcast()V

    .line 1546
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 1548
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 1549
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/model/RadioStorage;->getFavoriteForBand(I)Ljava/util/List;

    move-result-object v0

    .line 1551
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v3

    if-lez v3, :cond_1

    .line 1552
    invoke-virtual {p0, v1}, Lcom/saicmotor/radio/service/RadioService$6;->openRadioBand(I)I

    .line 1553
    invoke-interface {v0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/car/radio/service/RadioStation;

    invoke-virtual {p0, v0}, Lcom/saicmotor/radio/service/RadioService$6;->tune(Lcom/android/car/radio/service/RadioStation;)V

    goto :goto_2

    .line 1555
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/model/RadioStorage;->getFavoriteForBand(I)Ljava/util/List;

    move-result-object v0

    .line 1557
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    if-lez v1, :cond_2

    .line 1558
    invoke-virtual {p0, v2}, Lcom/saicmotor/radio/service/RadioService$6;->openRadioBand(I)I

    .line 1559
    invoke-interface {v0, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/android/car/radio/service/RadioStation;

    invoke-virtual {p0, v0}, Lcom/saicmotor/radio/service/RadioService$6;->tune(Lcom/android/car/radio/service/RadioStation;)V

    :cond_2
    :goto_2
    return-void

    :catchall_0
    move-exception v1

    .line 1546
    :try_start_3
    monitor-exit v0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    throw v1
.end method

.method public queryDabStationList()V
    .locals 1

    .line 1961
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 1962
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/DabRadioStationManager;->queryDabStationList()V

    :cond_0
    return-void
.end method

.method public removeDabTunerCallback(Lcom/android/car/radio/service/IDabCallback;)V
    .locals 2

    .line 1898
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    if-nez v0, :cond_0

    .line 1899
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object p1

    const-string v0, "removeDrmTunerCallback() dab is not initialize"

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->e(Ljava/lang/String;)V

    return-void

    .line 1902
    :cond_0
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "removeDabTunerCallback()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    if-nez p1, :cond_1

    return-void

    .line 1906
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$4000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v0

    monitor-enter v0

    .line 1907
    :try_start_0
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$4000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v1

    invoke-virtual {v1, p1}, Landroid/os/RemoteCallbackList;->unregister(Landroid/os/IInterface;)Z

    .line 1908
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method public removeRadioTunerCallback(Lcom/android/car/radio/service/IRadioCallback;)V
    .locals 3

    .line 1433
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "removeRadioTunerCallback():"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    if-nez p1, :cond_0

    return-void

    .line 1439
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v0

    monitor-enter v0

    .line 1440
    :try_start_0
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v1

    invoke-virtual {v1, p1}, Landroid/os/RemoteCallbackList;->unregister(Landroid/os/IInterface;)Z

    .line 1441
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method public resetpara(II)V
    .locals 3

    .line 1520
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "resetpara() address: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " length: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1521
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-nez v0, :cond_0

    return-void

    .line 1524
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getRadioTuner()Landroid/hardware/radio/RadioTuner;

    move-result-object v0

    if-nez v0, :cond_1

    .line 1525
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v1

    invoke-static {v0, v1}, Lcom/saicmotor/radio/service/RadioService;->access$2800(Lcom/saicmotor/radio/service/RadioService;I)I

    move-result v0

    const/high16 v1, -0x80000000

    if-ne v0, v1, :cond_1

    return-void

    .line 1530
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0, p1, p2}, Lcom/saicmotor/radio/manager/RadioStationManager;->resetpara(II)V

    return-void
.end method

.method public resumeRadioPlaying()V
    .locals 4

    .line 1968
    invoke-virtual {p0}, Lcom/saicmotor/radio/service/RadioService$6;->hasFocus()Z

    move-result v0

    .line 1969
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "resumeRadioPlaying  isCPMediaRequestAudioFocus = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v3}, Lcom/saicmotor/radio/service/RadioService;->access$4100(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, "   hasFocus = "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1970
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$4200(Lcom/saicmotor/radio/service/RadioService;)Ljava/lang/Object;

    move-result-object v1

    monitor-enter v1

    .line 1971
    :try_start_0
    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$4100(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v2

    if-eqz v2, :cond_0

    if-nez v0, :cond_0

    .line 1973
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v2

    invoke-static {v0, v2}, Lcom/saicmotor/radio/service/RadioService;->access$4300(Lcom/saicmotor/radio/service/RadioService;I)V

    .line 1976
    :cond_0
    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method public scan()V
    .locals 3

    .line 1276
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "scan()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1277
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2500(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1278
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "openTunerFmAm() Failed."

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void

    .line 1282
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 1283
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "scan "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v2

    invoke-virtual {v2}, Lcom/saicmotor/radio/manager/RadioStationManager;->getScanStatus()Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, "  seek "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v2

    invoke-virtual {v2}, Lcom/saicmotor/radio/manager/RadioStationManager;->getSearchStatus()Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1284
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getScanStatus()Z

    move-result v0

    if-eqz v0, :cond_1

    return-void

    .line 1287
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getSearchStatus()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 1291
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->cancel()V

    .line 1292
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$700(Lcom/saicmotor/radio/service/RadioService;)V

    .line 1293
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2300(Lcom/saicmotor/radio/service/RadioService;)Lcom/android/car/radio/service/RadioStation;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 1294
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2300(Lcom/saicmotor/radio/service/RadioService;)Lcom/android/car/radio/service/RadioStation;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/service/RadioService;->tuneRadioTune(Lcom/android/car/radio/service/RadioStation;)V

    .line 1298
    :cond_2
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/manager/RadioStationManager;->scan(I)V

    :cond_3
    return-void
.end method

.method public seekBackward()V
    .locals 3

    .line 1185
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "seekBackward()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1186
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-nez v0, :cond_0

    return-void

    .line 1190
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getScanStatus()Z

    move-result v0

    if-eqz v0, :cond_1

    return-void

    .line 1193
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getSearchStatus()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 1194
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->cancel()V

    .line 1195
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2300(Lcom/saicmotor/radio/service/RadioService;)Lcom/android/car/radio/service/RadioStation;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 1196
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2300(Lcom/saicmotor/radio/service/RadioService;)Lcom/android/car/radio/service/RadioStation;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/service/RadioService;->tuneRadioTune(Lcom/android/car/radio/service/RadioStation;)V

    :cond_2
    return-void

    .line 1201
    :cond_3
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v1

    invoke-virtual {p0}, Lcom/saicmotor/radio/service/RadioService$6;->getCurrentRadioStation()Lcom/android/car/radio/service/RadioStation;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/saicmotor/radio/model/RadioStorage;->getPreValidStation(ILcom/android/car/radio/service/RadioStation;)Lcom/android/car/radio/service/RadioStation;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 1203
    invoke-virtual {p0}, Lcom/saicmotor/radio/service/RadioService$6;->getCurrentRadioStation()Lcom/android/car/radio/service/RadioStation;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/car/radio/service/RadioStation;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_4

    .line 1204
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v1

    const-string v2, "seek; has station found, tune station"

    invoke-virtual {v1, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1205
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-virtual {v1, v0}, Lcom/saicmotor/radio/service/RadioService;->tuneRadioTune(Lcom/android/car/radio/service/RadioStation;)V

    return-void

    .line 1208
    :cond_4
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v0

    if-eqz v0, :cond_5

    .line 1209
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "mCurrentRadioBand = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void

    .line 1212
    :cond_5
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2500(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v0

    if-nez v0, :cond_6

    .line 1213
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "openTunerFmAm() Failed."

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void

    .line 1217
    :cond_6
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/manager/RadioStationManager;->seek(Z)V

    return-void
.end method

.method public seekForward()V
    .locals 3

    .line 1147
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "seekForward()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1148
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-nez v0, :cond_0

    return-void

    .line 1152
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getScanStatus()Z

    move-result v0

    if-eqz v0, :cond_1

    return-void

    .line 1155
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getSearchStatus()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 1156
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->cancel()V

    .line 1157
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2300(Lcom/saicmotor/radio/service/RadioService;)Lcom/android/car/radio/service/RadioStation;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 1158
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2300(Lcom/saicmotor/radio/service/RadioService;)Lcom/android/car/radio/service/RadioStation;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/service/RadioService;->tuneRadioTune(Lcom/android/car/radio/service/RadioStation;)V

    :cond_2
    return-void

    .line 1163
    :cond_3
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v1

    invoke-virtual {p0}, Lcom/saicmotor/radio/service/RadioService$6;->getCurrentRadioStation()Lcom/android/car/radio/service/RadioStation;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Lcom/saicmotor/radio/model/RadioStorage;->getNextValidStation(ILcom/android/car/radio/service/RadioStation;)Lcom/android/car/radio/service/RadioStation;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 1165
    invoke-virtual {p0}, Lcom/saicmotor/radio/service/RadioService$6;->getCurrentRadioStation()Lcom/android/car/radio/service/RadioStation;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/car/radio/service/RadioStation;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_4

    .line 1166
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v1

    const-string v2, "seek; has station found, tune station"

    invoke-virtual {v1, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1167
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-virtual {v1, v0}, Lcom/saicmotor/radio/service/RadioService;->tuneRadioTune(Lcom/android/car/radio/service/RadioStation;)V

    return-void

    .line 1170
    :cond_4
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v0

    if-eqz v0, :cond_5

    .line 1171
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "mCurrentRadioBand = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void

    .line 1174
    :cond_5
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2500(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v0

    if-nez v0, :cond_6

    .line 1175
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "openTunerFmAm() Failed."

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void

    .line 1179
    :cond_6
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/manager/RadioStationManager;->seek(Z)V

    return-void
.end method

.method public setDabAnnouncement(Landroid/hardware/radio/RadioDabInfo$AnnouncementInfo;)V
    .locals 0

    return-void
.end method

.method public setFavoriteStatus(Z)V
    .locals 5

    .line 1569
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "setFavoriteStatus() status: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1571
    new-instance v0, Lcom/android/car/radio/service/RadioStation;

    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$500(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v1

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    .line 1572
    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v2

    const/4 v3, 0x0

    const/4 v4, 0x0

    invoke-direct {v0, v1, v3, v2, v4}, Lcom/android/car/radio/service/RadioStation;-><init>(IIILcom/android/car/radio/service/RadioRds;)V

    .line 1573
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v1

    if-eqz v1, :cond_1

    .line 1574
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/saicmotor/radio/model/RadioStorage;->isFavorite(Lcom/android/car/radio/service/RadioStation;)Z

    move-result v1

    .line 1576
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v2

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Toggling favorite for "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v4, "\n\tIs currently a favorite: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    if-eqz p1, :cond_0

    if-nez v1, :cond_0

    .line 1580
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object p1

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/model/RadioStorage;->storeFavorite(Lcom/android/car/radio/service/RadioStation;)V

    goto :goto_0

    :cond_0
    if-nez p1, :cond_1

    if-eqz v1, :cond_1

    .line 1582
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object p1

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/model/RadioStorage;->removeFavorite(Lcom/android/car/radio/service/RadioStation;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public setRadioMBSCallback(Lcom/android/car/radio/service/IRadioMBSCallback;)V
    .locals 3

    .line 1871
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "setRadioMBSCallback()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1872
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "setRadioMBSCallback():"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    if-nez p1, :cond_0

    return-void

    .line 1876
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v0

    monitor-enter v0

    .line 1877
    :try_start_0
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$1900(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v1

    invoke-virtual {v1, p1}, Landroid/os/RemoteCallbackList;->register(Landroid/os/IInterface;)Z

    .line 1878
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method public setpara(I[I)I
    .locals 3

    .line 1505
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "setpara() address: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " para: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1506
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 1509
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getRadioTuner()Landroid/hardware/radio/RadioTuner;

    move-result-object v0

    if-nez v0, :cond_1

    .line 1510
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v2

    invoke-static {v0, v2}, Lcom/saicmotor/radio/service/RadioService;->access$2800(Lcom/saicmotor/radio/service/RadioService;I)I

    move-result v0

    const/high16 v2, -0x80000000

    if-ne v0, v2, :cond_1

    return v1

    .line 1515
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0, p1, p2}, Lcom/saicmotor/radio/manager/RadioStationManager;->setpara(I[I)I

    move-result p1

    return p1
.end method

.method public stepBackward()V
    .locals 2

    .line 1233
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "stepBackward()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1234
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2500(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1235
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "openTunerFmAm() Failed."

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void

    .line 1238
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 1239
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/manager/RadioStationManager;->step(Z)V

    :cond_1
    return-void
.end method

.method public stepForward()V
    .locals 2

    .line 1222
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2500(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1223
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "openTunerFmAm() Failed."

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void

    .line 1226
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 1227
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/manager/RadioStationManager;->step(Z)V

    :cond_1
    return-void
.end method

.method public stopDabAnnouncement()V
    .locals 1

    .line 1954
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 1955
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/DabRadioStationManager;->stopDabAnnouncement()V

    :cond_0
    return-void
.end method

.method public tune(Lcom/android/car/radio/service/RadioStation;)V
    .locals 3

    .line 1141
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "tune()  radioStation = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1142
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/service/RadioService;->tuneRadioTune(Lcom/android/car/radio/service/RadioStation;)V

    return-void
.end method

.method public tuneStop(Z)V
    .locals 3

    .line 1623
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "tuneStop() isStop: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1624
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 1625
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/manager/RadioStationManager;->tuneStop(Z)V

    .line 1626
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getRadioTuner()Landroid/hardware/radio/RadioTuner;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 1628
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/manager/RadioStationManager;->tuneStop(Z)V

    .line 1629
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0, p1}, Lcom/saicmotor/radio/service/RadioService;->access$2902(Lcom/saicmotor/radio/service/RadioService;Z)Z

    if-eqz p1, :cond_0

    .line 1631
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$3000(Lcom/saicmotor/radio/service/RadioService;)V

    goto :goto_0

    .line 1633
    :cond_0
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$3100(Lcom/saicmotor/radio/service/RadioService;)V

    :cond_1
    :goto_0
    return-void
.end method

.method public unMute()Z
    .locals 3

    .line 1359
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "unMute()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 1360
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2600(Lcom/saicmotor/radio/service/RadioService;)Landroid/media/AudioManager;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 1361
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v2, "toggleMute() called, but not connected to CarAudioManager"

    invoke-virtual {v0, v2}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return v1

    .line 1365
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$6;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2700(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_1

    move v1, v2

    :cond_1
    return v1
.end method
