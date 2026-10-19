.class public Lcom/saicmotor/radio/view/widget/TabLayout;
.super Ljava/lang/Object;
.source "TabLayout.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/saicmotor/radio/view/widget/TabLayout$Builder;,
        Lcom/saicmotor/radio/view/widget/TabLayout$OnTabClickListener;
    }
.end annotation


# static fields
.field private static final DOUBLE_CLICK_TIMEOUT:J = 0x12cL

.field private static final LOG:Lcom/saicmotor/radio/utils/log/Logger;

.field private static mLastClickTime:J


# instance fields
.field private hasAM:Z

.field private hasDAB:Z

.field private hasFM:Z

.field private final mIvTabAmLine1:Landroid/widget/ImageView;

.field private final mIvTabDabLine1:Landroid/widget/ImageView;

.field private final mIvTabFmLine1:Landroid/widget/ImageView;

.field private mListener:Lcom/saicmotor/radio/view/widget/TabLayout$OnTabClickListener;

.field private final mRlMenuBar:Landroid/widget/LinearLayout;

.field private final tabAMRl:Landroid/widget/RelativeLayout;

.field private final tabDabRl:Landroid/widget/RelativeLayout;

.field private final tabFMRl:Landroid/widget/RelativeLayout;

.field private view:Landroid/view/View;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 27
    new-instance v0, Lcom/saicmotor/radio/utils/log/Logger;

    const-class v1, Lcom/saicmotor/radio/view/widget/TabLayout;

    invoke-direct {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;-><init>(Ljava/lang/Class;)V

    sput-object v0, Lcom/saicmotor/radio/view/widget/TabLayout;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/view/ViewGroup;)V
    .locals 9

    .line 49
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-string v0, "layout_inflater"

    .line 50
    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/view/LayoutInflater;

    const v0, 0x7f0b0058

    const/4 v1, 0x0

    const/4 v2, 0x0

    .line 51
    invoke-virtual {p1, v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->view:Landroid/view/View;

    .line 52
    new-instance p1, Landroidx/constraintlayout/widget/ConstraintSet;

    invoke-direct {p1}, Landroidx/constraintlayout/widget/ConstraintSet;-><init>()V

    .line 53
    check-cast p2, Landroidx/constraintlayout/widget/ConstraintLayout;

    .line 54
    iget-object v0, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->view:Landroid/view/View;

    invoke-virtual {p2, v0, v2}, Landroidx/constraintlayout/widget/ConstraintLayout;->addView(Landroid/view/View;I)V

    .line 55
    invoke-virtual {p1, p2}, Landroidx/constraintlayout/widget/ConstraintSet;->clone(Landroidx/constraintlayout/widget/ConstraintLayout;)V

    .line 56
    invoke-static {}, Lcom/saicmotor/radio/app/RadioApp;->getAppContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/saicmotor/radio/utils/ViewUtils;->isPortraitSize(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_0

    const v4, 0x7f0800dc

    const/4 v5, 0x3

    .line 57
    invoke-virtual {p2}, Landroidx/constraintlayout/widget/ConstraintLayout;->getId()I

    move-result v6

    const/4 v7, 0x3

    const/16 v8, 0x80

    move-object v3, p1

    invoke-virtual/range {v3 .. v8}, Landroidx/constraintlayout/widget/ConstraintSet;->connect(IIIII)V

    .line 59
    :cond_0
    invoke-static {}, Lcom/saicmotor/radio/app/RadioApp;->getAppContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/saicmotor/radio/utils/ViewUtils;->getWhellPosition(Landroid/content/Context;)I

    move-result v0

    const/4 v1, 0x2

    const v2, 0x7f0800dc

    if-ne v0, v1, :cond_1

    .line 60
    invoke-virtual {p2}, Landroidx/constraintlayout/widget/ConstraintLayout;->getId()I

    move-result v0

    const/4 v1, 0x7

    invoke-virtual {p1, v2, v1, v0, v1}, Landroidx/constraintlayout/widget/ConstraintSet;->connect(IIII)V

    goto :goto_0

    .line 62
    :cond_1
    invoke-virtual {p2}, Landroidx/constraintlayout/widget/ConstraintLayout;->getId()I

    move-result v0

    const/4 v1, 0x6

    invoke-virtual {p1, v2, v1, v0, v1}, Landroidx/constraintlayout/widget/ConstraintSet;->connect(IIII)V

    .line 64
    :goto_0
    invoke-virtual {p1, p2}, Landroidx/constraintlayout/widget/ConstraintSet;->applyTo(Landroidx/constraintlayout/widget/ConstraintLayout;)V

    .line 66
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->view:Landroid/view/View;

    const p2, 0x7f08011e

    invoke-virtual {p1, p2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/LinearLayout;

    iput-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    .line 67
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->view:Landroid/view/View;

    const p2, 0x7f0800e4

    invoke-virtual {p1, p2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/RelativeLayout;

    iput-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->tabDabRl:Landroid/widget/RelativeLayout;

    .line 68
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->view:Landroid/view/View;

    const p2, 0x7f0800e5

    invoke-virtual {p1, p2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/RelativeLayout;

    iput-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->tabFMRl:Landroid/widget/RelativeLayout;

    .line 69
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->view:Landroid/view/View;

    const p2, 0x7f0800e3

    invoke-virtual {p1, p2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/RelativeLayout;

    iput-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->tabAMRl:Landroid/widget/RelativeLayout;

    .line 70
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->view:Landroid/view/View;

    const p2, 0x7f0800cf

    invoke-virtual {p1, p2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ImageView;

    iput-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabDabLine1:Landroid/widget/ImageView;

    .line 71
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->view:Landroid/view/View;

    const p2, 0x7f0800d0

    invoke-virtual {p1, p2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ImageView;

    iput-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabFmLine1:Landroid/widget/ImageView;

    .line 72
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->view:Landroid/view/View;

    const p2, 0x7f0800ce

    invoke-virtual {p1, p2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ImageView;

    iput-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabAmLine1:Landroid/widget/ImageView;

    .line 73
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->tabDabRl:Landroid/widget/RelativeLayout;

    invoke-virtual {p1, p0}, Landroid/widget/RelativeLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 74
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->tabFMRl:Landroid/widget/RelativeLayout;

    invoke-virtual {p1, p0}, Landroid/widget/RelativeLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 75
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->tabAMRl:Landroid/widget/RelativeLayout;

    invoke-virtual {p1, p0}, Landroid/widget/RelativeLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 76
    invoke-virtual {p0}, Lcom/saicmotor/radio/view/widget/TabLayout;->fitFeatureMap()V

    return-void
.end method

.method static synthetic access$002(Lcom/saicmotor/radio/view/widget/TabLayout;Lcom/saicmotor/radio/view/widget/TabLayout$OnTabClickListener;)Lcom/saicmotor/radio/view/widget/TabLayout$OnTabClickListener;
    .locals 0

    .line 26
    iput-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mListener:Lcom/saicmotor/radio/view/widget/TabLayout$OnTabClickListener;

    return-object p1
.end method

.method private declared-synchronized isFastClick()Z
    .locals 5

    monitor-enter p0

    .line 239
    :try_start_0
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    .line 240
    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v1

    sget-wide v3, Lcom/saicmotor/radio/view/widget/TabLayout;->mLastClickTime:J

    sub-long/2addr v1, v3

    const-wide/16 v3, 0x12c

    cmp-long v1, v1, v3

    if-gez v1, :cond_0

    const/4 v1, 0x1

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    .line 241
    :goto_0
    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    sput-wide v2, Lcom/saicmotor/radio/view/widget/TabLayout;->mLastClickTime:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 242
    monitor-exit p0

    return v1

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0
.end method


# virtual methods
.method public fitFeatureMap()V
    .locals 5

    .line 97
    sget-object v0, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->size()I

    move-result v0

    if-lez v0, :cond_6

    .line 98
    sget-object v0, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    const-string v1, "radio_DAB___"

    invoke-interface {v0, v1}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    sget-object v0, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    const-string v2, "radio_FM___"

    invoke-interface {v0, v2}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    sget-object v0, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    const-string v3, "radio_AM___"

    .line 99
    invoke-interface {v0, v3}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 100
    invoke-static {v1}, Lcom/saicmotor/radio/utils/FeatureUtil;->getValueForKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "1"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    iput-boolean v0, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasDAB:Z

    .line 101
    invoke-static {v2}, Lcom/saicmotor/radio/utils/FeatureUtil;->getValueForKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    iput-boolean v0, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasFM:Z

    .line 102
    invoke-static {v3}, Lcom/saicmotor/radio/utils/FeatureUtil;->getValueForKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    iput-boolean v0, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasAM:Z

    .line 103
    sget-object v0, Lcom/saicmotor/radio/view/widget/TabLayout;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "fitFeatureMap->hasDAB:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v2, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasDAB:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, "_hasFM:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v2, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasFM:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v2, "_hasAM:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-boolean v2, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasAM:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 104
    iget-object v0, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->tabDabRl:Landroid/widget/RelativeLayout;

    iget-boolean v1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasDAB:Z

    const/16 v2, 0x8

    const/4 v3, 0x0

    if-eqz v1, :cond_0

    move v1, v3

    goto :goto_0

    :cond_0
    move v1, v2

    :goto_0
    invoke-virtual {v0, v1}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    .line 105
    iget-object v0, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabDabLine1:Landroid/widget/ImageView;

    iget-boolean v1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasDAB:Z

    const/4 v4, 0x4

    if-eqz v1, :cond_1

    move v1, v3

    goto :goto_1

    :cond_1
    move v1, v4

    :goto_1
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 106
    iget-object v0, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->tabFMRl:Landroid/widget/RelativeLayout;

    iget-boolean v1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasFM:Z

    if-eqz v1, :cond_2

    move v1, v3

    goto :goto_2

    :cond_2
    move v1, v2

    :goto_2
    invoke-virtual {v0, v1}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    .line 107
    iget-object v0, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabFmLine1:Landroid/widget/ImageView;

    iget-boolean v1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasFM:Z

    if-eqz v1, :cond_3

    move v1, v3

    goto :goto_3

    :cond_3
    move v1, v4

    :goto_3
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 108
    iget-object v0, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->tabAMRl:Landroid/widget/RelativeLayout;

    iget-boolean v1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasAM:Z

    if-eqz v1, :cond_4

    move v2, v3

    :cond_4
    invoke-virtual {v0, v2}, Landroid/widget/RelativeLayout;->setVisibility(I)V

    .line 109
    iget-object v0, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabAmLine1:Landroid/widget/ImageView;

    iget-boolean v1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasAM:Z

    if-eqz v1, :cond_5

    goto :goto_4

    :cond_5
    move v3, v4

    :goto_4
    invoke-virtual {v0, v3}, Landroid/widget/ImageView;->setVisibility(I)V

    :cond_6
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 1

    .line 218
    invoke-direct {p0}, Lcom/saicmotor/radio/view/widget/TabLayout;->isFastClick()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 219
    sget-object p1, Lcom/saicmotor/radio/view/widget/TabLayout;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    const-string v0, "is Fast Click"

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void

    .line 223
    :cond_0
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    const/4 v0, 0x1

    packed-switch p1, :pswitch_data_0

    goto :goto_0

    :pswitch_0
    const/4 v0, 0x4

    goto :goto_0

    :pswitch_1
    const/4 v0, 0x0

    .line 234
    :goto_0
    :pswitch_2
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mListener:Lcom/saicmotor/radio/view/widget/TabLayout$OnTabClickListener;

    if-eqz p1, :cond_1

    .line 235
    invoke-interface {p1, v0}, Lcom/saicmotor/radio/view/widget/TabLayout$OnTabClickListener;->onTabClick(I)V

    :cond_1
    return-void

    :pswitch_data_0
    .packed-switch 0x7f0800e3
        :pswitch_1
        :pswitch_0
        :pswitch_2
    .end packed-switch
.end method

.method public setBandTypeChange(I)V
    .locals 10

    .line 115
    iget-object v0, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->tabDabRl:Landroid/widget/RelativeLayout;

    const/4 v1, 0x1

    const/4 v2, 0x0

    const/4 v3, 0x4

    if-ne p1, v3, :cond_0

    move v4, v1

    goto :goto_0

    :cond_0
    move v4, v2

    :goto_0
    invoke-static {v0, v4}, Lcom/saicmotor/radio/utils/ViewUtils;->setViewAndChildrenSelected(Landroid/view/View;Z)V

    .line 116
    iget-object v0, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->tabFMRl:Landroid/widget/RelativeLayout;

    if-ne p1, v1, :cond_1

    move v4, v1

    goto :goto_1

    :cond_1
    move v4, v2

    :goto_1
    invoke-static {v0, v4}, Lcom/saicmotor/radio/utils/ViewUtils;->setViewAndChildrenSelected(Landroid/view/View;Z)V

    .line 117
    iget-object v0, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->tabAMRl:Landroid/widget/RelativeLayout;

    if-nez p1, :cond_2

    move v4, v1

    goto :goto_2

    :cond_2
    move v4, v2

    :goto_2
    invoke-static {v0, v4}, Lcom/saicmotor/radio/utils/ViewUtils;->setViewAndChildrenSelected(Landroid/view/View;Z)V

    const/4 v0, 0x2

    const v4, 0x7f0c00df

    const-string v5, "1"

    const v6, 0x7f0c00de

    const-string v7, "radio_DAB___"

    if-eqz p1, :cond_14

    const v8, 0x7f0c00dd

    const v9, 0x7f0c00dc

    if-eq p1, v1, :cond_7

    if-eq p1, v3, :cond_3

    goto/16 :goto_c

    .line 120
    :cond_3
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabDabLine1:Landroid/widget/ImageView;

    invoke-virtual {p1, v3}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 121
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabFmLine1:Landroid/widget/ImageView;

    invoke-virtual {p1, v2}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 122
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabAmLine1:Landroid/widget/ImageView;

    iget-boolean v1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasAM:Z

    if-eqz v1, :cond_4

    goto :goto_3

    :cond_4
    move v2, v3

    :goto_3
    invoke-virtual {p1, v2}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 123
    invoke-static {}, Lcom/saicmotor/radio/app/RadioApp;->getAppContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/saicmotor/radio/utils/ViewUtils;->is1920Size(Landroid/content/Context;)Z

    move-result p1

    if-eqz p1, :cond_5

    .line 124
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v9}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 125
    :cond_5
    invoke-static {}, Lcom/saicmotor/radio/app/RadioApp;->getAppContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/saicmotor/radio/utils/ViewUtils;->is1280Size(Landroid/content/Context;)Z

    move-result p1

    if-eqz p1, :cond_21

    .line 126
    invoke-static {}, Lcom/saicmotor/radio/app/RadioApp;->getAppContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/saicmotor/radio/utils/ViewUtils;->getWhellPosition(Landroid/content/Context;)I

    move-result p1

    if-ne p1, v0, :cond_6

    .line 127
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v8}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 129
    :cond_6
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v9}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 134
    :cond_7
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabDabLine1:Landroid/widget/ImageView;

    invoke-virtual {p1, v3}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 135
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabFmLine1:Landroid/widget/ImageView;

    invoke-virtual {p1, v3}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 136
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabAmLine1:Landroid/widget/ImageView;

    iget-boolean v1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasAM:Z

    if-eqz v1, :cond_8

    goto :goto_4

    :cond_8
    move v2, v3

    :goto_4
    invoke-virtual {p1, v2}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 137
    invoke-static {}, Lcom/saicmotor/radio/app/RadioApp;->getAppContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/saicmotor/radio/utils/ViewUtils;->is1920Size(Landroid/content/Context;)Z

    move-result p1

    if-eqz p1, :cond_c

    .line 138
    sget-object p1, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    invoke-interface {p1}, Ljava/util/Map;->size()I

    move-result p1

    if-lez p1, :cond_b

    .line 139
    sget-object p1, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    invoke-interface {p1, v7}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_a

    .line 140
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {v7}, Lcom/saicmotor/radio/utils/FeatureUtil;->getValueForKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_9

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v6}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    goto :goto_5

    :cond_9
    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v9}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    :goto_5
    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 142
    :cond_a
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v6}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 145
    :cond_b
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v6}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 147
    :cond_c
    invoke-static {}, Lcom/saicmotor/radio/app/RadioApp;->getAppContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/saicmotor/radio/utils/ViewUtils;->is1280Size(Landroid/content/Context;)Z

    move-result p1

    if-eqz p1, :cond_21

    .line 148
    invoke-static {}, Lcom/saicmotor/radio/app/RadioApp;->getAppContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/saicmotor/radio/utils/ViewUtils;->getWhellPosition(Landroid/content/Context;)I

    move-result p1

    if-ne p1, v0, :cond_10

    .line 149
    sget-object p1, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    invoke-interface {p1}, Ljava/util/Map;->size()I

    move-result p1

    if-lez p1, :cond_f

    .line 150
    sget-object p1, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    invoke-interface {p1, v7}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_e

    .line 151
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {v7}, Lcom/saicmotor/radio/utils/FeatureUtil;->getValueForKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_d

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v4}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    goto :goto_6

    :cond_d
    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v8}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    :goto_6
    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 153
    :cond_e
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v4}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 156
    :cond_f
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v4}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 159
    :cond_10
    sget-object p1, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    invoke-interface {p1}, Ljava/util/Map;->size()I

    move-result p1

    if-lez p1, :cond_13

    .line 160
    sget-object p1, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    invoke-interface {p1, v7}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_12

    .line 161
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {v7}, Lcom/saicmotor/radio/utils/FeatureUtil;->getValueForKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_11

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v6}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    goto :goto_7

    :cond_11
    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v9}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    :goto_7
    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 163
    :cond_12
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v6}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 166
    :cond_13
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v6}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 172
    :cond_14
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabDabLine1:Landroid/widget/ImageView;

    iget-boolean v1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->hasDAB:Z

    if-eqz v1, :cond_15

    goto :goto_8

    :cond_15
    move v2, v3

    :goto_8
    invoke-virtual {p1, v2}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 173
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabFmLine1:Landroid/widget/ImageView;

    invoke-virtual {p1, v3}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 174
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mIvTabAmLine1:Landroid/widget/ImageView;

    invoke-virtual {p1, v3}, Landroid/widget/ImageView;->setVisibility(I)V

    .line 175
    invoke-static {}, Lcom/saicmotor/radio/app/RadioApp;->getAppContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/saicmotor/radio/utils/ViewUtils;->is1920Size(Landroid/content/Context;)Z

    move-result p1

    const v1, 0x7f0c00e0

    if-eqz p1, :cond_19

    .line 176
    sget-object p1, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    invoke-interface {p1}, Ljava/util/Map;->size()I

    move-result p1

    if-lez p1, :cond_18

    .line 177
    sget-object p1, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    invoke-interface {p1, v7}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_17

    .line 178
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {v7}, Lcom/saicmotor/radio/utils/FeatureUtil;->getValueForKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_16

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    goto :goto_9

    :cond_16
    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v6}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    :goto_9
    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 180
    :cond_17
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 183
    :cond_18
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto/16 :goto_c

    .line 185
    :cond_19
    invoke-static {}, Lcom/saicmotor/radio/app/RadioApp;->getAppContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/saicmotor/radio/utils/ViewUtils;->is1280Size(Landroid/content/Context;)Z

    move-result p1

    if-eqz p1, :cond_21

    .line 186
    invoke-static {}, Lcom/saicmotor/radio/app/RadioApp;->getAppContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/saicmotor/radio/utils/ViewUtils;->getWhellPosition(Landroid/content/Context;)I

    move-result p1

    if-ne p1, v0, :cond_1d

    .line 187
    sget-object p1, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    invoke-interface {p1}, Ljava/util/Map;->size()I

    move-result p1

    const v0, 0x7f0c00e1

    if-lez p1, :cond_1c

    .line 188
    sget-object p1, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    invoke-interface {p1, v7}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1b

    .line 189
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {v7}, Lcom/saicmotor/radio/utils/FeatureUtil;->getValueForKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1a

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    goto :goto_a

    :cond_1a
    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v4}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    :goto_a
    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto :goto_c

    .line 191
    :cond_1b
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto :goto_c

    .line 194
    :cond_1c
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto :goto_c

    .line 197
    :cond_1d
    sget-object p1, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    invoke-interface {p1}, Ljava/util/Map;->size()I

    move-result p1

    if-lez p1, :cond_20

    .line 198
    sget-object p1, Lcom/saicmotor/radio/utils/FeatureUtil;->mFeatureMap:Ljava/util/Map;

    invoke-interface {p1, v7}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1f

    .line 199
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {v7}, Lcom/saicmotor/radio/utils/FeatureUtil;->getValueForKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1e

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    goto :goto_b

    :cond_1e
    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v6}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    :goto_b
    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto :goto_c

    .line 201
    :cond_1f
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    goto :goto_c

    .line 204
    :cond_20
    iget-object p1, p0, Lcom/saicmotor/radio/view/widget/TabLayout;->mRlMenuBar:Landroid/widget/LinearLayout;

    invoke-static {}, Lcom/saicmotor/skinloader/loader/SkinManager;->getInstance()Lcom/saicmotor/skinloader/loader/SkinManager;

    move-result-object v0

    invoke-virtual {v0, v1}, Lcom/saicmotor/skinloader/loader/SkinManager;->getTrueDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    # MG4-Radio-Dash : barre d'onglets sans image (le reflet cyan d'origine clignotait au-dessus des puces)

    :cond_21
    :goto_c
    return-void
.end method

.method public updateSkinType()V
    .locals 1

    .line 213
    invoke-static {}, Lcom/saicmotor/radio/app/RadioApp;->getAppContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/saicmotor/radio/model/RadioStorage;->getInstance(Landroid/content/Context;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/model/RadioStorage;->getStoredRadioBand()I

    move-result v0

    invoke-virtual {p0, v0}, Lcom/saicmotor/radio/view/widget/TabLayout;->setBandTypeChange(I)V

    return-void
.end method
