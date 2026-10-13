.class public Lcom/saicmotor/radio/view/RadioMainActivity;
.super Lcom/saicmotor/radio/base/BaseActivity;
.source "RadioMainActivity.java"

# interfaces
.implements Lcom/saicmotor/radio/contract/CarRadioContract$ICarRadioMainView;
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/saicmotor/radio/base/BaseActivity<",
        "Lcom/saicmotor/radio/contract/CarRadioContract$ICarRadioMainView;",
        "Lcom/saicmotor/radio/presenter/CarRadioMainPresenter;",
        ">;",
        "Lcom/saicmotor/radio/contract/CarRadioContract$ICarRadioMainView;",
        "Landroid/view/View$OnClickListener;"
    }
.end annotation


# static fields
.field public static final EXTRA_START_FROM_LAUNCHER:Ljava/lang/String; = "startFromLauncher"

.field private static final LOG:Lcom/saicmotor/radio/utils/log/Logger;


# instance fields
.field private layoutRoot:Landroidx/constraintlayout/widget/ConstraintLayout;

.field private mBandAmFragment:Lcom/saicmotor/radio/view/fragment/AmFragment;

.field private mBandDabFragment:Lcom/saicmotor/radio/view/fragment/DabFragment;

.field private mBandFmFragment:Lcom/saicmotor/radio/view/fragment/FmFragment;

.field private mDabListFragment:Lcom/saicmotor/radio/view/fragment/DabListFragment;

.field private mDabListFrameLayout:Landroid/widget/FrameLayout;

.field private mFmAmListFragment:Lcom/saicmotor/radio/view/fragment/FmAmListFragment;

.field private mFmAmListFrameLayout:Landroid/widget/FrameLayout;

.field private mRadioCardFragment:Lcom/saicmotor/radio/view/fragment/RadioCardFragment;

.field private mShowListType:I

.field private final mUIRequestListener:Lcom/saicmotor/radio/listener/UIRequestListener;

.field private tabLayout:Lcom/saicmotor/radio/view/widget/TabLayout;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 44
    new-instance v0, Lcom/saicmotor/radio/utils/log/Logger;

    const-class v1, Lcom/saicmotor/radio/view/RadioMainActivity;

    invoke-direct {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;-><init>(Ljava/lang/Class;)V

    sput-object v0, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    return-void
.end method

.method public constructor <init>()V
    .locals 1

    .line 42
    invoke-direct {p0}, Lcom/saicmotor/radio/base/BaseActivity;-><init>()V

    .line 155
    new-instance v0, Lcom/saicmotor/radio/view/RadioMainActivity$2;

    invoke-direct {v0, p0}, Lcom/saicmotor/radio/view/RadioMainActivity$2;-><init>(Lcom/saicmotor/radio/view/RadioMainActivity;)V

    iput-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mUIRequestListener:Lcom/saicmotor/radio/listener/UIRequestListener;

    return-void
.end method

.method static synthetic access$000()Lcom/saicmotor/radio/utils/log/Logger;
    .locals 1

    .line 42
    sget-object v0, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    return-object v0
.end method

.method static synthetic access$100(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/base/BasePresenter;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    return-object p0
.end method

.method static synthetic access$1000(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/view/fragment/FmFragment;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandFmFragment:Lcom/saicmotor/radio/view/fragment/FmFragment;

    return-object p0
.end method

.method static synthetic access$1100(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/view/fragment/AmFragment;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandAmFragment:Lcom/saicmotor/radio/view/fragment/AmFragment;

    return-object p0
.end method

.method static synthetic access$1200(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/base/BasePresenter;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    return-object p0
.end method

.method static synthetic access$1300(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/base/BasePresenter;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    return-object p0
.end method

.method static synthetic access$1400(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/base/BasePresenter;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    return-object p0
.end method

.method static synthetic access$1500(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/base/BasePresenter;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    return-object p0
.end method

.method static synthetic access$1600(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/base/BasePresenter;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    return-object p0
.end method

.method static synthetic access$1700(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/base/BasePresenter;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    return-object p0
.end method

.method static synthetic access$1800(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/view/fragment/DabListFragment;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mDabListFragment:Lcom/saicmotor/radio/view/fragment/DabListFragment;

    return-object p0
.end method

.method static synthetic access$1900(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/view/fragment/DabFragment;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandDabFragment:Lcom/saicmotor/radio/view/fragment/DabFragment;

    return-object p0
.end method

.method static synthetic access$200(Lcom/saicmotor/radio/view/RadioMainActivity;)I
    .locals 0

    .line 42
    iget p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mShowListType:I

    return p0
.end method

.method static synthetic access$202(Lcom/saicmotor/radio/view/RadioMainActivity;I)I
    .locals 0

    .line 42
    iput p1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mShowListType:I

    return p1
.end method

.method static synthetic access$300(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/view/fragment/FmAmListFragment;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mFmAmListFragment:Lcom/saicmotor/radio/view/fragment/FmAmListFragment;

    return-object p0
.end method

.method static synthetic access$400(Lcom/saicmotor/radio/view/RadioMainActivity;)Landroid/widget/FrameLayout;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mFmAmListFrameLayout:Landroid/widget/FrameLayout;

    return-object p0
.end method

.method static synthetic access$500(Lcom/saicmotor/radio/view/RadioMainActivity;)Landroid/widget/FrameLayout;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mDabListFrameLayout:Landroid/widget/FrameLayout;

    return-object p0
.end method

.method static synthetic access$600(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/listener/UIRequestListener;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mUIRequestListener:Lcom/saicmotor/radio/listener/UIRequestListener;

    return-object p0
.end method

.method static synthetic access$700(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/view/fragment/RadioCardFragment;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mRadioCardFragment:Lcom/saicmotor/radio/view/fragment/RadioCardFragment;

    return-object p0
.end method

.method static synthetic access$800(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/base/BasePresenter;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    return-object p0
.end method

.method static synthetic access$900(Lcom/saicmotor/radio/view/RadioMainActivity;)Lcom/saicmotor/radio/base/BasePresenter;
    .locals 0

    .line 42
    iget-object p0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    return-object p0
.end method

.method private startRadioBandFragment(Lcom/saicmotor/radio/base/BaseFragment;)V
    .locals 2

    .line 495
    sget-object v0, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    const-string v1, "startRadioBandFragment()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 497
    invoke-virtual {p0}, Lcom/saicmotor/radio/view/RadioMainActivity;->getFragmentManager()Landroid/app/FragmentManager;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/FragmentManager;->beginTransaction()Landroid/app/FragmentTransaction;

    move-result-object v0

    const v1, 0x7f0800b0

    .line 498
    invoke-virtual {v0, v1, p1}, Landroid/app/FragmentTransaction;->replace(ILandroid/app/Fragment;)Landroid/app/FragmentTransaction;

    move-result-object p1

    .line 499
    invoke-virtual {p1}, Landroid/app/FragmentTransaction;->commitAllowingStateLoss()I

    return-void
.end method

.method private updateTabDisplay(I)V
    .locals 1

    .line 484
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mRadioCardFragment:Lcom/saicmotor/radio/view/fragment/RadioCardFragment;

    if-eqz v0, :cond_0

    .line 485
    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/view/fragment/RadioCardFragment;->updateRadioBandType(I)V

    .line 487
    :cond_0
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->tabLayout:Lcom/saicmotor/radio/view/widget/TabLayout;

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/view/widget/TabLayout;->setBandTypeChange(I)V

    return-void
.end method


# virtual methods
.method protected bridge synthetic createPresenter()Lcom/saicmotor/radio/base/BasePresenter;
    .locals 1

    .line 42
    invoke-virtual {p0}, Lcom/saicmotor/radio/view/RadioMainActivity;->createPresenter()Lcom/saicmotor/radio/presenter/CarRadioMainPresenter;

    move-result-object v0

    return-object v0
.end method

.method protected createPresenter()Lcom/saicmotor/radio/presenter/CarRadioMainPresenter;
    .locals 1

    .line 62
    new-instance v0, Lcom/saicmotor/radio/presenter/CarRadioMainPresenter;

    invoke-direct {v0, p0}, Lcom/saicmotor/radio/presenter/CarRadioMainPresenter;-><init>(Landroid/content/Context;)V

    return-object v0
.end method

.method protected initView()V
    .locals 2

    .line 85
    sget-object v0, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    const-string v1, "initView()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    const v0, 0x7f08007c

    .line 86
    invoke-virtual {p0, v0}, Lcom/saicmotor/radio/view/RadioMainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroidx/constraintlayout/widget/ConstraintLayout;

    iput-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->layoutRoot:Landroidx/constraintlayout/widget/ConstraintLayout;

    .line 87
    new-instance v0, Lcom/saicmotor/radio/view/widget/TabLayout$Builder;

    iget-object v1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->layoutRoot:Landroidx/constraintlayout/widget/ConstraintLayout;

    invoke-direct {v0, p0, v1}, Lcom/saicmotor/radio/view/widget/TabLayout$Builder;-><init>(Landroid/content/Context;Landroid/view/ViewGroup;)V

    new-instance v1, Lcom/saicmotor/radio/view/RadioMainActivity$1;

    invoke-direct {v1, p0}, Lcom/saicmotor/radio/view/RadioMainActivity$1;-><init>(Lcom/saicmotor/radio/view/RadioMainActivity;)V

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/view/widget/TabLayout$Builder;->setOnTabClickListener(Lcom/saicmotor/radio/view/widget/TabLayout$OnTabClickListener;)Lcom/saicmotor/radio/view/widget/TabLayout$Builder;

    move-result-object v0

    .line 94
    invoke-virtual {v0}, Lcom/saicmotor/radio/view/widget/TabLayout$Builder;->create()Lcom/saicmotor/radio/view/widget/TabLayout;

    move-result-object v0

    iput-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->tabLayout:Lcom/saicmotor/radio/view/widget/TabLayout;

    const v0, 0x7f0800aa

    .line 96
    invoke-virtual {p0, v0}, Lcom/saicmotor/radio/view/RadioMainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout;

    iput-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mFmAmListFrameLayout:Landroid/widget/FrameLayout;

    .line 97
    invoke-virtual {p0}, Lcom/saicmotor/radio/view/RadioMainActivity;->getFragmentManager()Landroid/app/FragmentManager;

    move-result-object v0

    const v1, 0x7f0800ac

    invoke-virtual {v0, v1}, Landroid/app/FragmentManager;->findFragmentById(I)Landroid/app/Fragment;

    move-result-object v0

    check-cast v0, Lcom/saicmotor/radio/view/fragment/FmAmListFragment;

    iput-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mFmAmListFragment:Lcom/saicmotor/radio/view/fragment/FmAmListFragment;

    .line 98
    iget-object v1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mUIRequestListener:Lcom/saicmotor/radio/listener/UIRequestListener;

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/view/fragment/FmAmListFragment;->setUIRequestListener(Lcom/saicmotor/radio/listener/UIRequestListener;)V

    const v0, 0x7f0800a9

    .line 100
    invoke-virtual {p0, v0}, Lcom/saicmotor/radio/view/RadioMainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout;

    iput-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mDabListFrameLayout:Landroid/widget/FrameLayout;

    .line 101
    invoke-virtual {p0}, Lcom/saicmotor/radio/view/RadioMainActivity;->getFragmentManager()Landroid/app/FragmentManager;

    move-result-object v0

    const v1, 0x7f080086

    invoke-virtual {v0, v1}, Landroid/app/FragmentManager;->findFragmentById(I)Landroid/app/Fragment;

    move-result-object v0

    check-cast v0, Lcom/saicmotor/radio/view/fragment/DabListFragment;

    iput-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mDabListFragment:Lcom/saicmotor/radio/view/fragment/DabListFragment;

    .line 102
    iget-object v1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mUIRequestListener:Lcom/saicmotor/radio/listener/UIRequestListener;

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/view/fragment/DabListFragment;->setUIRequestListener(Lcom/saicmotor/radio/listener/UIRequestListener;)V

    .line 104
    invoke-virtual {p0}, Lcom/saicmotor/radio/view/RadioMainActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/saicmotor/radio/model/RadioStorage;->getInstance(Landroid/content/Context;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    invoke-virtual {v0}, Lcom/saicmotor/radio/model/RadioStorage;->getStoredRadioBand()I

    move-result v0

    invoke-direct {p0, v0}, Lcom/saicmotor/radio/view/RadioMainActivity;->updateTabDisplay(I)V

    .line 105
    invoke-static {p0}, Lcom/saicmotor/radio/model/RadioStorage;->getInstance(Landroid/content/Context;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 107
    invoke-virtual {v0}, Lcom/saicmotor/radio/model/RadioStorage;->getStoredRadioListType()I

    move-result v0

    iput v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mShowListType:I

    :cond_0
    return-void
.end method

.method public onChannelBandUpdate(I)V
    .locals 3

    .line 504
    sget-object v0, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onChannelBandUpdate(): "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 505
    invoke-direct {p0, p1}, Lcom/saicmotor/radio/view/RadioMainActivity;->updateTabDisplay(I)V

    if-eqz p1, :cond_2

    const/4 v0, 0x1

    if-eq p1, v0, :cond_1

    const/4 v0, 0x4

    if-eq p1, v0, :cond_0

    .line 517
    sget-object p1, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    const-string v0, "Band ERROR!"

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->e(Ljava/lang/String;)V

    goto :goto_0

    .line 514
    :cond_0
    iget-object p1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandDabFragment:Lcom/saicmotor/radio/view/fragment/DabFragment;

    invoke-direct {p0, p1}, Lcom/saicmotor/radio/view/RadioMainActivity;->startRadioBandFragment(Lcom/saicmotor/radio/base/BaseFragment;)V

    goto :goto_0

    .line 508
    :cond_1
    iget-object p1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandFmFragment:Lcom/saicmotor/radio/view/fragment/FmFragment;

    invoke-direct {p0, p1}, Lcom/saicmotor/radio/view/RadioMainActivity;->startRadioBandFragment(Lcom/saicmotor/radio/base/BaseFragment;)V

    goto :goto_0

    .line 511
    :cond_2
    iget-object p1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandAmFragment:Lcom/saicmotor/radio/view/fragment/AmFragment;

    invoke-direct {p0, p1}, Lcom/saicmotor/radio/view/RadioMainActivity;->startRadioBandFragment(Lcom/saicmotor/radio/base/BaseFragment;)V

    :goto_0
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 0

    return-void
.end method

.method public onCreate(Landroid/os/Bundle;)V
    .locals 2

    .line 123
    invoke-super {p0, p1}, Lcom/saicmotor/radio/base/BaseActivity;->onCreate(Landroid/os/Bundle;)V

    .line 124
    sget-object p1, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    const-string v0, "onCreate()"

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 126
    new-instance p1, Lcom/saicmotor/radio/view/fragment/FmFragment;

    invoke-direct {p1}, Lcom/saicmotor/radio/view/fragment/FmFragment;-><init>()V

    iput-object p1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandFmFragment:Lcom/saicmotor/radio/view/fragment/FmFragment;

    .line 127
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mUIRequestListener:Lcom/saicmotor/radio/listener/UIRequestListener;

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/view/fragment/FmFragment;->setUIRequestListener(Lcom/saicmotor/radio/listener/UIRequestListener;)V

    .line 128
    new-instance p1, Landroid/os/Bundle;

    invoke-direct {p1}, Landroid/os/Bundle;-><init>()V

    const-string v0, "RADIO_BAND"

    const-string v1, "FM"

    .line 129
    invoke-virtual {p1, v0, v1}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 130
    iget-object v1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandFmFragment:Lcom/saicmotor/radio/view/fragment/FmFragment;

    invoke-virtual {v1, p1}, Lcom/saicmotor/radio/view/fragment/FmFragment;->setArguments(Landroid/os/Bundle;)V

    .line 132
    new-instance p1, Lcom/saicmotor/radio/view/fragment/AmFragment;

    invoke-direct {p1}, Lcom/saicmotor/radio/view/fragment/AmFragment;-><init>()V

    iput-object p1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandAmFragment:Lcom/saicmotor/radio/view/fragment/AmFragment;

    .line 133
    iget-object v1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mUIRequestListener:Lcom/saicmotor/radio/listener/UIRequestListener;

    invoke-virtual {p1, v1}, Lcom/saicmotor/radio/view/fragment/AmFragment;->setUIRequestListener(Lcom/saicmotor/radio/listener/UIRequestListener;)V

    .line 134
    new-instance p1, Landroid/os/Bundle;

    invoke-direct {p1}, Landroid/os/Bundle;-><init>()V

    const-string v1, "AM"

    .line 135
    invoke-virtual {p1, v0, v1}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 136
    iget-object v1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandAmFragment:Lcom/saicmotor/radio/view/fragment/AmFragment;

    invoke-virtual {v1, p1}, Lcom/saicmotor/radio/view/fragment/AmFragment;->setArguments(Landroid/os/Bundle;)V

    .line 138
    new-instance p1, Lcom/saicmotor/radio/view/fragment/DabFragment;

    invoke-direct {p1}, Lcom/saicmotor/radio/view/fragment/DabFragment;-><init>()V

    iput-object p1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandDabFragment:Lcom/saicmotor/radio/view/fragment/DabFragment;

    .line 139
    iget-object v1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mUIRequestListener:Lcom/saicmotor/radio/listener/UIRequestListener;

    invoke-virtual {p1, v1}, Lcom/saicmotor/radio/view/fragment/DabFragment;->setUIRequestListener(Lcom/saicmotor/radio/listener/UIRequestListener;)V

    .line 140
    new-instance p1, Landroid/os/Bundle;

    invoke-direct {p1}, Landroid/os/Bundle;-><init>()V

    const-string v1, "DAB"

    .line 141
    invoke-virtual {p1, v0, v1}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 142
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandDabFragment:Lcom/saicmotor/radio/view/fragment/DabFragment;

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/view/fragment/DabFragment;->setArguments(Landroid/os/Bundle;)V

    .line 144
    invoke-virtual {p0}, Lcom/saicmotor/radio/view/RadioMainActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/saicmotor/radio/utils/ViewUtils;->is1920Size(Landroid/content/Context;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 145
    new-instance p1, Lcom/saicmotor/radio/view/fragment/RadioCardFragment;

    invoke-direct {p1}, Lcom/saicmotor/radio/view/fragment/RadioCardFragment;-><init>()V

    iput-object p1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mRadioCardFragment:Lcom/saicmotor/radio/view/fragment/RadioCardFragment;

    .line 146
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mUIRequestListener:Lcom/saicmotor/radio/listener/UIRequestListener;

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/view/fragment/RadioCardFragment;->setUIRequestListener(Lcom/saicmotor/radio/listener/UIRequestListener;)V

    .line 147
    invoke-virtual {p0}, Lcom/saicmotor/radio/view/RadioMainActivity;->getFragmentManager()Landroid/app/FragmentManager;

    move-result-object p1

    invoke-virtual {p1}, Landroid/app/FragmentManager;->beginTransaction()Landroid/app/FragmentTransaction;

    move-result-object p1

    const v0, 0x7f0800b1

    iget-object v1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mRadioCardFragment:Lcom/saicmotor/radio/view/fragment/RadioCardFragment;

    .line 148
    invoke-virtual {p1, v0, v1}, Landroid/app/FragmentTransaction;->replace(ILandroid/app/Fragment;)Landroid/app/FragmentTransaction;

    move-result-object p1

    .line 149
    invoke-virtual {p1}, Landroid/app/FragmentTransaction;->commitAllowingStateLoss()I

    :cond_0
    invoke-static {p0}, Lapp/mg4dash/radiodash/RadioDash;->onCreate(Landroid/app/Activity;)V

    return-void
.end method

.method protected onDestroy()V
    .locals 2

    .line 472
    invoke-super {p0}, Lcom/saicmotor/radio/base/BaseActivity;->onDestroy()V

    .line 473
    sget-object v0, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    const-string v1, "onDestroy()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 474
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    if-eqz v0, :cond_0

    .line 475
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    check-cast v0, Lcom/saicmotor/radio/presenter/CarRadioMainPresenter;

    invoke-virtual {v0}, Lcom/saicmotor/radio/presenter/CarRadioMainPresenter;->shutdown()V

    :cond_0
    return-void
.end method

.method protected onNewIntent(Landroid/content/Intent;)V
    .locals 3

    .line 417
    invoke-super {p0, p1}, Lcom/saicmotor/radio/base/BaseActivity;->onNewIntent(Landroid/content/Intent;)V

    .line 418
    sget-object p1, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    const-string v0, "onNewIntent()"

    invoke-virtual {p1, v0}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 419
    invoke-static {p0}, Lcom/saicmotor/radio/model/RadioStorage;->getInstance(Landroid/content/Context;)Lcom/saicmotor/radio/model/RadioStorage;

    move-result-object p1

    invoke-virtual {p1}, Lcom/saicmotor/radio/model/RadioStorage;->getStoredRadioBand()I

    move-result p1

    .line 420
    sget-object v0, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "onNewIntent curRadioBand = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 421
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    if-eqz v0, :cond_0

    .line 422
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    check-cast v0, Lcom/saicmotor/radio/presenter/CarRadioMainPresenter;

    invoke-virtual {v0, p1}, Lcom/saicmotor/radio/presenter/CarRadioMainPresenter;->openRadioBand(I)V

    :cond_0
    return-void
.end method

.method public onNotifyScanFinish()V
    .locals 1

    .line 525
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mFmAmListFragment:Lcom/saicmotor/radio/view/fragment/FmAmListFragment;

    if-eqz v0, :cond_0

    .line 526
    invoke-virtual {v0}, Lcom/saicmotor/radio/view/fragment/FmAmListFragment;->notifyScanFinished()V

    :cond_0
    return-void
.end method

.method public onNotifyScanStart()V
    .locals 1

    .line 532
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mFmAmListFragment:Lcom/saicmotor/radio/view/fragment/FmAmListFragment;

    if-eqz v0, :cond_0

    .line 533
    invoke-virtual {v0}, Lcom/saicmotor/radio/view/fragment/FmAmListFragment;->notifyScanStarted()V

    :cond_0
    return-void
.end method

.method protected onPause()V
    .locals 3

    .line 456
    invoke-super {p0}, Lcom/saicmotor/radio/base/BaseActivity;->onPause()V

    .line 457
    sget-object v0, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    const-string v1, "onPause()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 458
    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    const-string v1, "startFromLauncher"

    const/4 v2, 0x0

    .line 459
    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    .line 460
    iget-object v1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandFmFragment:Lcom/saicmotor/radio/view/fragment/FmFragment;

    invoke-virtual {v1, v0}, Lcom/saicmotor/radio/view/fragment/FmFragment;->setArguments(Landroid/os/Bundle;)V

    .line 461
    iget-object v1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mBandAmFragment:Lcom/saicmotor/radio/view/fragment/AmFragment;

    invoke-virtual {v1, v0}, Lcom/saicmotor/radio/view/fragment/AmFragment;->setArguments(Landroid/os/Bundle;)V

    invoke-static {p0}, Lapp/mg4dash/radiodash/RadioDash;->onPause(Landroid/app/Activity;)V

    return-void
.end method

.method protected onResume()V
    .locals 2

    .line 445
    invoke-super {p0}, Lcom/saicmotor/radio/base/BaseActivity;->onResume()V

    .line 446
    sget-object v0, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    const-string v1, "onResume()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 447
    new-instance v0, Lcom/saicmotor/common/CommandParcelable;

    invoke-direct {v0}, Lcom/saicmotor/common/CommandParcelable;-><init>()V

    const/16 v1, 0x4004

    .line 448
    invoke-virtual {v0, v1}, Lcom/saicmotor/common/CommandParcelable;->setEvent(I)V

    .line 449
    invoke-virtual {p0}, Lcom/saicmotor/radio/view/RadioMainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/common/CommandParcelable;->setTargetPackage(Ljava/lang/String;)V

    .line 450
    invoke-virtual {p0}, Lcom/saicmotor/radio/view/RadioMainActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/saicmotor/common/CommandParcelable;->sendCommand(Landroid/content/Context;)V

    invoke-static {p0}, Lapp/mg4dash/radiodash/RadioDash;->onResume(Landroid/app/Activity;)V

    return-void
.end method

.method protected onStart()V
    .locals 2

    .line 431
    invoke-super {p0}, Lcom/saicmotor/radio/base/BaseActivity;->onStart()V

    .line 432
    sget-object v0, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    const-string v1, "onStart()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 434
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    if-eqz v0, :cond_0

    .line 435
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    check-cast v0, Lcom/saicmotor/radio/presenter/CarRadioMainPresenter;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/presenter/CarRadioMainPresenter;->initialize(Landroid/view/View;)V

    .line 436
    iget-object v0, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->mPresenter:Lcom/saicmotor/radio/base/BasePresenter;

    check-cast v0, Lcom/saicmotor/radio/presenter/CarRadioMainPresenter;

    invoke-virtual {v0}, Lcom/saicmotor/radio/presenter/CarRadioMainPresenter;->start()V

    :cond_0
    return-void
.end method

.method protected onStop()V
    .locals 2

    .line 466
    invoke-super {p0}, Lcom/saicmotor/radio/base/BaseActivity;->onStop()V

    .line 467
    sget-object v0, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    const-string v1, "onStop()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    return-void
.end method

.method public onUpdateSkinEvent(Lcom/saicmotor/radio/model/event/UpdateSkinEvent;)V
    .locals 0
    .annotation runtime Lorg/greenrobot/eventbus/Subscribe;
        threadMode = .enum Lorg/greenrobot/eventbus/ThreadMode;->MAIN:Lorg/greenrobot/eventbus/ThreadMode;
    .end annotation

    .line 405
    iget-object p1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->tabLayout:Lcom/saicmotor/radio/view/widget/TabLayout;

    invoke-virtual {p1}, Lcom/saicmotor/radio/view/widget/TabLayout;->updateSkinType()V

    return-void
.end method

.method public onUpdateTabLayout(Lcom/saicmotor/radio/model/event/UpdateTabLayout;)V
    .locals 0
    .annotation runtime Lorg/greenrobot/eventbus/Subscribe;
        threadMode = .enum Lorg/greenrobot/eventbus/ThreadMode;->MAIN:Lorg/greenrobot/eventbus/ThreadMode;
    .end annotation

    .line 410
    iget-object p1, p0, Lcom/saicmotor/radio/view/RadioMainActivity;->tabLayout:Lcom/saicmotor/radio/view/widget/TabLayout;

    if-eqz p1, :cond_0

    .line 411
    invoke-virtual {p1}, Lcom/saicmotor/radio/view/widget/TabLayout;->fitFeatureMap()V

    :cond_0
    return-void
.end method

.method protected setLayoutId()I
    .locals 2

    .line 72
    sget-object v0, Lcom/saicmotor/radio/view/RadioMainActivity;->LOG:Lcom/saicmotor/radio/utils/log/Logger;

    const-string v1, "setLayoutId()"

    invoke-virtual {v0, v1}, Lcom/saicmotor/radio/utils/log/Logger;->i(Ljava/lang/String;)V

    .line 73
    invoke-virtual {p0}, Lcom/saicmotor/radio/view/RadioMainActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/saicmotor/radio/utils/ViewUtils;->getWhellPosition(Landroid/content/Context;)I

    move-result v0

    const/4 v1, 0x2

    if-ne v0, v1, :cond_0

    const v0, 0x7f0b001d

    return v0

    :cond_0
    const v0, 0x7f0b001c

    return v0
.end method

.method protected setListeners()V
    .locals 0

    return-void
.end method
