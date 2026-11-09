.class public Lcom/android/car/radio/service/RadioRds;
.super Ljava/lang/Object;
.source "RadioRds.java"

# interfaces
.implements Landroid/os/Parcelable;


# static fields
.field public static final CREATOR:Landroid/os/Parcelable$Creator;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroid/os/Parcelable$Creator<",
            "Lcom/android/car/radio/service/RadioRds;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private mProgramService:Ljava/lang/String;

.field private mSongArtist:Ljava/lang/String;

.field private mSongTitle:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 109
    new-instance v0, Lcom/android/car/radio/service/RadioRds$1;

    invoke-direct {v0}, Lcom/android/car/radio/service/RadioRds$1;-><init>()V

    sput-object v0, Lcom/android/car/radio/service/RadioRds;->CREATOR:Landroid/os/Parcelable$Creator;

    return-void
.end method

.method private constructor <init>(Landroid/os/Parcel;)V
    .locals 1

    .line 45
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 46
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/car/radio/service/RadioRds;->mProgramService:Ljava/lang/String;

    .line 47
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/android/car/radio/service/RadioRds;->mSongArtist:Ljava/lang/String;

    .line 48
    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/android/car/radio/service/RadioRds;->mSongTitle:Ljava/lang/String;

    return-void
.end method

.method synthetic constructor <init>(Landroid/os/Parcel;Lcom/android/car/radio/service/RadioRds$1;)V
    .locals 0

    .line 27
    invoke-direct {p0, p1}, Lcom/android/car/radio/service/RadioRds;-><init>(Landroid/os/Parcel;)V

    return-void
.end method

.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 39
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    # Radio Dash : nom de station et titres RDS avec leurs lettres accentuées (jeu EBU), voir app.mg4dash.radiodash.Rds
    invoke-static {p1}, Lapp/mg4dash/radiodash/Rds;->decode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-static {p2}, Lapp/mg4dash/radiodash/Rds;->decode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    invoke-static {p3}, Lapp/mg4dash/radiodash/Rds;->decode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    .line 40
    iput-object p1, p0, Lcom/android/car/radio/service/RadioRds;->mProgramService:Ljava/lang/String;

    .line 41
    iput-object p2, p0, Lcom/android/car/radio/service/RadioRds;->mSongArtist:Ljava/lang/String;

    .line 42
    iput-object p3, p0, Lcom/android/car/radio/service/RadioRds;->mSongTitle:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public describeContents()I
    .locals 1

    const/4 v0, 0x0

    return v0
.end method

.method public equals(Ljava/lang/Object;)Z
    .locals 4

    const/4 v0, 0x1

    if-ne p1, p0, :cond_0

    return v0

    .line 89
    :cond_0
    instance-of v1, p1, Lcom/android/car/radio/service/RadioRds;

    const/4 v2, 0x0

    if-nez v1, :cond_1

    return v2

    .line 93
    :cond_1
    check-cast p1, Lcom/android/car/radio/service/RadioRds;

    .line 94
    iget-object v1, p0, Lcom/android/car/radio/service/RadioRds;->mProgramService:Ljava/lang/String;

    invoke-virtual {p1}, Lcom/android/car/radio/service/RadioRds;->getProgramService()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v3}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    iget-object v1, p0, Lcom/android/car/radio/service/RadioRds;->mSongArtist:Ljava/lang/String;

    .line 95
    invoke-virtual {p1}, Lcom/android/car/radio/service/RadioRds;->getSongArtist()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v3}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    iget-object v1, p0, Lcom/android/car/radio/service/RadioRds;->mSongTitle:Ljava/lang/String;

    .line 96
    invoke-virtual {p1}, Lcom/android/car/radio/service/RadioRds;->getSongTitle()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2

    goto :goto_0

    :cond_2
    move v0, v2

    :goto_0
    return v0
.end method

.method public getProgramService()Ljava/lang/String;
    .locals 1

    .line 60
    iget-object v0, p0, Lcom/android/car/radio/service/RadioRds;->mProgramService:Ljava/lang/String;

    return-object v0
.end method

.method public getSongArtist()Ljava/lang/String;
    .locals 1

    .line 65
    iget-object v0, p0, Lcom/android/car/radio/service/RadioRds;->mSongArtist:Ljava/lang/String;

    return-object v0
.end method

.method public getSongTitle()Ljava/lang/String;
    .locals 1

    .line 70
    iget-object v0, p0, Lcom/android/car/radio/service/RadioRds;->mSongTitle:Ljava/lang/String;

    return-object v0
.end method

.method public hashCode()I
    .locals 3

    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/Object;

    .line 101
    iget-object v1, p0, Lcom/android/car/radio/service/RadioRds;->mProgramService:Ljava/lang/String;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/car/radio/service/RadioRds;->mSongArtist:Ljava/lang/String;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/car/radio/service/RadioRds;->mSongTitle:Ljava/lang/String;

    const/4 v2, 0x2

    aput-object v1, v0, v2

    invoke-static {v0}, Ljava/util/Objects;->hash([Ljava/lang/Object;)I

    move-result v0

    return v0
.end method

.method public toString()Ljava/lang/String;
    .locals 3

    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/Object;

    .line 75
    iget-object v1, p0, Lcom/android/car/radio/service/RadioRds;->mProgramService:Ljava/lang/String;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/car/radio/service/RadioRds;->mSongArtist:Ljava/lang/String;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    iget-object v1, p0, Lcom/android/car/radio/service/RadioRds;->mSongTitle:Ljava/lang/String;

    const/4 v2, 0x2

    aput-object v1, v0, v2

    const-string v1, "RadioRds [ps: %s, song artist: %s, song title: %s]"

    invoke-static {v1, v0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public writeToParcel(Landroid/os/Parcel;I)V
    .locals 0

    .line 53
    iget-object p2, p0, Lcom/android/car/radio/service/RadioRds;->mProgramService:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 54
    iget-object p2, p0, Lcom/android/car/radio/service/RadioRds;->mSongArtist:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 55
    iget-object p2, p0, Lcom/android/car/radio/service/RadioRds;->mSongTitle:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    return-void
.end method
