.class Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;
.super Landroid/hardware/radio/RadioTuner$Callback;
.source "RadioService.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/saicmotor/radio/service/RadioService;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "InternalRadioCallback"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/saicmotor/radio/service/RadioService;


# direct methods
.method private constructor <init>(Lcom/saicmotor/radio/service/RadioService;)V
    .locals 0

    .line 2038
    iput-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-direct {p0}, Landroid/hardware/radio/RadioTuner$Callback;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/saicmotor/radio/service/RadioService;Lcom/saicmotor/radio/service/RadioService$1;)V
    .locals 0

    .line 2038
    invoke-direct {p0, p1}, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;-><init>(Lcom/saicmotor/radio/service/RadioService;)V

    return-void
.end method


# virtual methods
.method public onAntennaState(Z)V
    .locals 3

    .line 2375
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback RadioTuner.Callback onAntennaState() = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void
.end method

.method public onBackgroundScanAvailabilityChange(Z)V
    .locals 3

    .line 2380
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onBackgroundScanAvailabilityChange() = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void
.end method

.method public onBackgroundScanComplete()V
    .locals 2

    .line 2385
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "RadioTuner.Callback onBackgroundScanComplete()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void
.end method

.method public onConfigurationChanged(Landroid/hardware/radio/RadioManager$BandConfig;)V
    .locals 3

    .line 2177
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onConfigurationChanged(): config: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void
.end method

.method public onControlChanged(Z)V
    .locals 2

    .line 2244
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "RadioTuner.Callback onControlChanged()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 2245
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-nez v0, :cond_0

    return-void

    :cond_0
    if-nez p1, :cond_1

    .line 2251
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/saicmotor/radio/manager/RadioStationManager;->closeRadio()V

    return-void

    .line 2255
    :cond_1
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/saicmotor/radio/manager/RadioStationManager;->getRadioTuner()Landroid/hardware/radio/RadioTuner;

    move-result-object p1

    if-nez p1, :cond_2

    .line 2256
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v0

    invoke-static {p1, v0}, Lcom/saicmotor/radio/service/RadioService;->access$2800(Lcom/saicmotor/radio/service/RadioService;I)I

    :cond_2
    return-void
.end method

.method public onEmergencyAnnouncement(Z)V
    .locals 3

    .line 2370
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onEmergencyAnnouncement = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void
.end method

.method public onError(I)V
    .locals 5

    .line 2203
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onError(); status: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 2204
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/saicmotor/radio/service/RadioService;->access$5002(Lcom/saicmotor/radio/service/RadioService;I)I

    const/16 v0, 0x64

    .line 2205
    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$5102(I)I

    if-eqz p1, :cond_0

    const/4 v0, 0x1

    if-ne p1, v0, :cond_3

    .line 2211
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 2212
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->closeRadioTuner()V

    .line 2214
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 2215
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1500(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/DabRadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/DabRadioStationManager;->closeDab()V

    .line 2219
    :cond_2
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/Handler;

    move-result-object v0

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$5200(Lcom/saicmotor/radio/service/RadioService;)Ljava/lang/Runnable;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 2220
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/Handler;

    move-result-object v0

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$5200(Lcom/saicmotor/radio/service/RadioService;)Ljava/lang/Runnable;

    move-result-object v2

    .line 2221
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$5100()I

    move-result v3

    int-to-long v3, v3

    .line 2220
    invoke-virtual {v0, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 2224
    :cond_3
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 2225
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/manager/RadioStationManager;->setScanStatus(Z)V

    .line 2226
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/manager/RadioStationManager;->setSearchStatus(Z)V

    .line 2229
    :cond_4
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v0

    monitor-enter v0

    .line 2230
    :try_start_0
    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v2

    invoke-virtual {v2}, Landroid/os/RemoteCallbackList;->beginBroadcast()I

    move-result v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :goto_0
    if-ge v1, v2, :cond_5

    .line 2233
    :try_start_1
    iget-object v3, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v3}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v3

    invoke-virtual {v3, v1}, Landroid/os/RemoteCallbackList;->getBroadcastItem(I)Landroid/os/IInterface;

    move-result-object v3

    check-cast v3, Lcom/android/car/radio/service/IRadioCallback;

    invoke-interface {v3, p1}, Lcom/android/car/radio/service/IRadioCallback;->onError(I)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_1

    :catch_0
    move-exception v3

    .line 2235
    :try_start_2
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v4

    invoke-virtual {v3}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 2238
    :cond_5
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object p1

    invoke-virtual {p1}, Landroid/os/RemoteCallbackList;->finishBroadcast()V

    .line 2239
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p1
.end method

.method public onMetadataChanged(Landroid/hardware/radio/RadioMetadata;)V
    .locals 3

    .line 2156
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onMetadataChanged(); metadata: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void
.end method

.method public onParametersUpdated(Ljava/util/Map;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 2041
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onParametersUpdated() parameters = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void
.end method

.method public onProgramInfoChanged(Landroid/hardware/radio/RadioManager$ProgramInfo;)V
    .locals 10

    .line 2051
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onProgramInfoChanged; band: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " info: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 2053
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    if-nez v0, :cond_0

    return-void

    .line 2057
    :cond_0
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onProgramInfoChanged  scanStatus = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v2

    invoke-virtual {v2}, Lcom/saicmotor/radio/manager/RadioStationManager;->getScanStatus()Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, "  seekStatus = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v2}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v2

    invoke-virtual {v2}, Lcom/saicmotor/radio/manager/RadioStationManager;->getSearchStatus()Z

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 2058
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getScanStatus()Z

    move-result v0

    const/4 v1, 0x2

    const/4 v2, 0x1

    if-eqz v0, :cond_1

    .line 2059
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/Handler;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/os/Handler;->hasMessages(I)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 2060
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/Handler;

    move-result-object v0

    const/4 v3, 0x3

    invoke-virtual {v0, v3}, Landroid/os/Handler;->removeMessages(I)V

    goto :goto_0

    .line 2062
    :cond_1
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/manager/RadioStationManager;->getSearchStatus()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 2063
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/Handler;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/os/Handler;->hasMessages(I)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 2064
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$2000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/Handler;

    move-result-object v0

    const/4 v3, 0x4

    invoke-virtual {v0, v3}, Landroid/os/Handler;->removeMessages(I)V

    .line 2067
    :cond_2
    :goto_0
    invoke-virtual {p1}, Landroid/hardware/radio/RadioManager$ProgramInfo;->getChannel()I

    move-result v0

    .line 2068
    invoke-virtual {p1}, Landroid/hardware/radio/RadioManager$ProgramInfo;->getSelector()Landroid/hardware/radio/ProgramSelector;

    move-result-object v3

    invoke-virtual {v3}, Landroid/hardware/radio/ProgramSelector;->getProgramType()I

    move-result v3

    .line 2070
    invoke-virtual {p1}, Landroid/hardware/radio/RadioManager$ProgramInfo;->getMetadata()Landroid/hardware/radio/RadioMetadata;

    move-result-object v4

    .line 2071
    invoke-virtual {p1}, Landroid/hardware/radio/RadioManager$ProgramInfo;->isTuned()Z

    move-result p1

    .line 2073
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v5

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "RadioTuner.Callback onProgramInfoChanged; programType -> "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, "    channel = "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    const/4 v5, 0x0

    if-ne v3, v2, :cond_3

    move v3, v5

    goto :goto_1

    :cond_3
    if-ne v3, v1, :cond_12

    .line 2079
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v3

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "onProgramInfoChanged-->radio_config_type = "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget v7, Lcom/saicmotor/radio/app/RadioApp;->mDabConfig:I

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v3, v6}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 2082
    sget v3, Lcom/saicmotor/radio/app/RadioApp;->mDabConfig:I

    if-eq v3, v2, :cond_4

    mul-int/lit8 v0, v0, 0xa

    :cond_4
    move v3, v2

    :goto_1
    const/4 v6, 0x0

    if-eqz v4, :cond_5

    const-string v7, "android.hardware.radio.metadata.RDS_PS"

    .line 2092
    invoke-virtual {v4, v7}, Landroid/hardware/radio/RadioMetadata;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const-string v8, "android.hardware.radio.metadata.ARTIST"

    .line 2093
    invoke-virtual {v4, v8}, Landroid/hardware/radio/RadioMetadata;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    const-string v9, "android.hardware.radio.metadata.TITLE"

    .line 2094
    invoke-virtual {v4, v9}, Landroid/hardware/radio/RadioMetadata;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 2096
    new-instance v9, Lcom/android/car/radio/service/RadioRds;

    invoke-direct {v9, v7, v8, v4}, Lcom/android/car/radio/service/RadioRds;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 2097
    new-instance v4, Lcom/android/car/radio/service/RadioStation;

    invoke-direct {v4, v0, v5, v3, v9}, Lcom/android/car/radio/service/RadioStation;-><init>(IIILcom/android/car/radio/service/RadioRds;)V

    goto :goto_2

    .line 2100
    :cond_5
    new-instance v4, Lcom/android/car/radio/service/RadioStation;

    invoke-direct {v4, v0, v5, v3, v6}, Lcom/android/car/radio/service/RadioStation;-><init>(IIILcom/android/car/radio/service/RadioRds;)V

    .line 2104
    :goto_2
    iget-object v7, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v7}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object v7

    invoke-virtual {v7}, Lcom/saicmotor/radio/manager/RadioStationManager;->getScanStatus()Z

    move-result v7

    const/16 v8, 0x3e8

    if-nez v7, :cond_8

    iget-object v7, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v7}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v7

    if-ne v7, v2, :cond_6

    goto :goto_3

    .line 2140
    :cond_6
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$1700(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/manager/RadioStationManager;

    move-result-object p1

    invoke-virtual {p1}, Lcom/saicmotor/radio/manager/RadioStationManager;->getSearchStatus()Z

    move-result p1

    if-eqz p1, :cond_11

    .line 2141
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1, v4}, Lcom/saicmotor/radio/service/RadioService;->access$2302(Lcom/saicmotor/radio/service/RadioService;Lcom/android/car/radio/service/RadioStation;)Lcom/android/car/radio/service/RadioStation;

    .line 2142
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1, v4}, Lcom/saicmotor/radio/service/RadioService;->access$4800(Lcom/saicmotor/radio/service/RadioService;Lcom/android/car/radio/service/RadioStation;)V

    .line 2143
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1, v4}, Lcom/saicmotor/radio/service/RadioService;->access$4900(Lcom/saicmotor/radio/service/RadioService;Lcom/android/car/radio/service/RadioStation;)V

    .line 2144
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$2000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/Handler;

    move-result-object p1

    invoke-virtual {p1, v1}, Landroid/os/Handler;->hasMessages(I)Z

    move-result p1

    if-eqz p1, :cond_7

    .line 2145
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$2000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/Handler;

    move-result-object p1

    invoke-virtual {p1, v1}, Landroid/os/Handler;->removeMessages(I)V

    .line 2147
    :cond_7
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1, v1, v4, v8}, Lcom/saicmotor/radio/service/RadioService;->access$4700(Lcom/saicmotor/radio/service/RadioService;ILjava/lang/Object;I)V

    goto/16 :goto_5

    .line 2105
    :cond_8
    :goto_3
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v7

    invoke-static {v1, v7, v0}, Lcom/saicmotor/radio/service/RadioService;->access$3500(Lcom/saicmotor/radio/service/RadioService;II)Z

    move-result v0

    .line 2106
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$300(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v1

    if-nez v1, :cond_a

    if-nez v0, :cond_a

    .line 2108
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object p1

    const-string v0, "channel is not available,return"

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 2109
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object p1

    if-eqz p1, :cond_9

    .line 2110
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$500(Lcom/saicmotor/radio/service/RadioService;)I

    move-result v0

    invoke-static {p1, v0}, Lcom/saicmotor/radio/service/RadioService;->access$600(Lcom/saicmotor/radio/service/RadioService;I)V

    :cond_9
    return-void

    :cond_a
    if-nez v0, :cond_b

    return-void

    :cond_b
    if-eqz p1, :cond_f

    if-ne v3, v2, :cond_e

    .line 2120
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$4400(Lcom/saicmotor/radio/service/RadioService;)Z

    move-result p1

    if-eqz p1, :cond_c

    .line 2121
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$4500(Lcom/saicmotor/radio/service/RadioService;)Ljava/util/List;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/List;->clear()V

    .line 2122
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1, v5}, Lcom/saicmotor/radio/service/RadioService;->access$4402(Lcom/saicmotor/radio/service/RadioService;Z)Z

    .line 2124
    :cond_c
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$4500(Lcom/saicmotor/radio/service/RadioService;)Ljava/util/List;

    move-result-object v0

    invoke-static {p1, v0, v4}, Lcom/saicmotor/radio/service/RadioService;->access$4600(Lcom/saicmotor/radio/service/RadioService;Ljava/util/List;Lcom/android/car/radio/service/RadioStation;)V

    .line 2125
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$2000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/Handler;

    move-result-object p1

    const/4 v0, 0x5

    invoke-virtual {p1, v0}, Landroid/os/Handler;->hasMessages(I)Z

    move-result p1

    if-eqz p1, :cond_d

    .line 2126
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$2000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/Handler;

    move-result-object p1

    invoke-virtual {p1, v0}, Landroid/os/Handler;->removeMessages(I)V

    .line 2128
    :cond_d
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1, v0, v6, v8}, Lcom/saicmotor/radio/service/RadioService;->access$4700(Lcom/saicmotor/radio/service/RadioService;ILjava/lang/Object;I)V

    goto :goto_4

    .line 2130
    :cond_e
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$400(Lcom/saicmotor/radio/service/RadioService;)Ljava/util/List;

    move-result-object v0

    invoke-static {p1, v0, v4}, Lcom/saicmotor/radio/service/RadioService;->access$4600(Lcom/saicmotor/radio/service/RadioService;Ljava/util/List;Lcom/android/car/radio/service/RadioStation;)V

    .line 2131
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$2400(Lcom/saicmotor/radio/service/RadioService;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object p1

    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$400(Lcom/saicmotor/radio/service/RadioService;)Ljava/util/List;

    move-result-object v0

    invoke-virtual {p1, v3, v0}, Lcom/saicmotor/radio/model/RadioStorage;->storePreScannedStations(ILjava/util/List;)V

    .line 2134
    :cond_f
    :goto_4
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$2000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/Handler;

    move-result-object p1

    invoke-virtual {p1, v2}, Landroid/os/Handler;->hasMessages(I)Z

    move-result p1

    if-eqz p1, :cond_10

    .line 2135
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$2000(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/Handler;

    move-result-object p1

    invoke-virtual {p1, v2}, Landroid/os/Handler;->removeMessages(I)V

    .line 2137
    :cond_10
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1, v2, v6, v8}, Lcom/saicmotor/radio/service/RadioService;->access$4700(Lcom/saicmotor/radio/service/RadioService;ILjava/lang/Object;I)V

    :cond_11
    :goto_5
    return-void

    .line 2086
    :cond_12
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object p1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "invalid programType -> "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->w(Ljava/lang/String;)V

    return-void
.end method

.method public onProgramListChanged()V
    .locals 2

    .line 2390
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    const-string v1, "RadioTuner.Callback onProgramListChanged()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void
.end method

.method public onRdsCTInfoChanged(Landroid/hardware/radio/RadioRdsInfo$CTInfo;)V
    .locals 3

    .line 2344
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onRdsCTInfoChanged = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/hardware/radio/RadioRdsInfo$CTInfo;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void
.end method

.method public onRdsMainInfoChanged(Landroid/hardware/radio/RadioRdsInfo$MainInfo;)V
    .locals 3

    # MG4Radio : nom de station RDS transmis à MG4Dash (la session média de la radio ne le reçoit pas)
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-virtual {p1}, Landroid/hardware/radio/RadioRdsInfo$MainInfo;->getPsName()[C

    move-result-object v1

    invoke-static {v0, v1}, Lapp/mg4dash/radiodash/RadioDash;->rdsName(Landroid/content/Context;[C)V

    .line 2262
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onRdsMainInfoChanged = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/hardware/radio/RadioRdsInfo$MainInfo;->getFrequency()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, "   mainInfo.getPsName() = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2263
    invoke-virtual {p1}, Landroid/hardware/radio/RadioRdsInfo$MainInfo;->getPsName()[C

    move-result-object v2

    invoke-static {v2}, Ljava/lang/String;->valueOf([C)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "   mainInfo.getPiCode() = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 2264
    invoke-virtual {p1}, Landroid/hardware/radio/RadioRdsInfo$MainInfo;->getPiCode()I

    move-result p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 2262
    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void
.end method

.method public onRdsRTTextChanged(Ljava/lang/String;)V
    .locals 5

    # Radio Dash : lettres accentuées du jeu de caractères RDS (EBU) remises en Unicode, pour la radio et MG4Dash
    invoke-static {p1}, Lapp/mg4dash/radiodash/Rds;->decode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    # MG4-Radio-Dash : texte RDS transmis à MG4Dash
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0, p1}, Lapp/mg4dash/radiodash/RadioDash;->rdsText(Landroid/content/Context;Ljava/lang/String;)V

    .line 2349
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onRdsRTTextChanged = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 2350
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v0

    monitor-enter v0

    .line 2351
    :try_start_0
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v1

    invoke-virtual {v1}, Landroid/os/RemoteCallbackList;->beginBroadcast()I

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    .line 2354
    :try_start_1
    iget-object v3, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v3}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v3

    invoke-virtual {v3, v2}, Landroid/os/RemoteCallbackList;->getBroadcastItem(I)Landroid/os/IInterface;

    move-result-object v3

    check-cast v3, Lcom/android/car/radio/service/IRadioCallback;

    invoke-interface {v3, p1}, Lcom/android/car/radio/service/IRadioCallback;->onRdsRTTextChanged(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_1

    :catch_0
    move-exception v3

    .line 2356
    :try_start_2
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v4

    invoke-virtual {v3}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 2359
    :cond_0
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object p1

    invoke-virtual {p1}, Landroid/os/RemoteCallbackList;->finishBroadcast()V

    .line 2360
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p1
.end method

.method public onRdsTAInfoChanged(Landroid/hardware/radio/RadioRdsInfo$TAInfo;)V
    .locals 7

    .line 2326
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onRdsTAInfoChanged = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/hardware/radio/RadioRdsInfo$TAInfo;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 2327
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v0

    monitor-enter v0

    .line 2328
    :try_start_0
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v1

    invoke-virtual {v1}, Landroid/os/RemoteCallbackList;->beginBroadcast()I

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    .line 2332
    :try_start_1
    iget-object v3, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v3}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v3

    invoke-virtual {v3, v2}, Landroid/os/RemoteCallbackList;->getBroadcastItem(I)Landroid/os/IInterface;

    move-result-object v3

    check-cast v3, Lcom/android/car/radio/service/IRadioCallback;

    invoke-virtual {p1}, Landroid/hardware/radio/RadioRdsInfo$TAInfo;->getTaAssertStatus()Z

    move-result v4

    invoke-virtual {p1}, Landroid/hardware/radio/RadioRdsInfo$TAInfo;->getFrequency()I

    move-result v5

    .line 2333
    invoke-virtual {p1}, Landroid/hardware/radio/RadioRdsInfo$TAInfo;->getPsName()[C

    move-result-object v6

    .line 2332
    invoke-interface {v3, v4, v5, v6}, Lcom/android/car/radio/service/IRadioCallback;->onRdsTAInfoChanged(ZI[C)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_1

    :catch_0
    move-exception v3

    .line 2335
    :try_start_2
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v4

    invoke-virtual {v3}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 2338
    :cond_0
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object p1

    invoke-virtual {p1}, Landroid/os/RemoteCallbackList;->finishBroadcast()V

    .line 2339
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p1
.end method

.method public onSignalInfoChanged(Landroid/hardware/radio/RadioSignal;)V
    .locals 3

    .line 2365
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onSignalInfoChanged = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/hardware/radio/RadioSignal;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void
.end method

.method public onTrafficAnnouncement(Z)V
    .locals 5

    .line 2310
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "RadioTuner.Callback onTrafficAnnouncement = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 2311
    iget-object v0, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v0}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v0

    monitor-enter v0

    .line 2312
    :try_start_0
    iget-object v1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v1}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v1

    invoke-virtual {v1}, Landroid/os/RemoteCallbackList;->beginBroadcast()I

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    .line 2315
    :try_start_1
    iget-object v3, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {v3}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object v3

    invoke-virtual {v3, v2}, Landroid/os/RemoteCallbackList;->getBroadcastItem(I)Landroid/os/IInterface;

    move-result-object v3

    check-cast v3, Lcom/android/car/radio/service/IRadioCallback;

    invoke-interface {v3, p1}, Lcom/android/car/radio/service/IRadioCallback;->onTrafficAnnouncement(Z)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_1

    :catch_0
    move-exception v3

    .line 2317
    :try_start_2
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object v4

    invoke-virtual {v3}, Ljava/lang/Exception;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 2320
    :cond_0
    iget-object p1, p0, Lcom/saicmotor/radio/service/RadioService$InternalRadioCallback;->this$0:Lcom/saicmotor/radio/service/RadioService;

    invoke-static {p1}, Lcom/saicmotor/radio/service/RadioService;->access$1600(Lcom/saicmotor/radio/service/RadioService;)Landroid/os/RemoteCallbackList;

    move-result-object p1

    invoke-virtual {p1}, Landroid/os/RemoteCallbackList;->finishBroadcast()V

    .line 2321
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p1

    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p1
.end method

.method public onTuneFailed(ILandroid/hardware/radio/ProgramSelector;)V
    .locals 2

    .line 2046
    invoke-static {}, Lcom/saicmotor/radio/service/RadioService;->access$200()Lcom/saicmotor/radio/utils/log/Logger;

    move-result-object p2

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "RadioTuner.Callback onTuneFailed() result = "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void
.end method
