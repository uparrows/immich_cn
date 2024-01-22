import { AssetResponseDto, AuthDto } from '@app/domain';
import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Next,
  Param,
  ParseFilePipe,
  Post,
  Query,
  Res,
  UploadedFiles,
  UseInterceptors,
  ValidationPipe,
} from '@nestjs/common';
import { ApiBody, ApiConsumes, ApiHeader, ApiOperation, ApiTags } from '@nestjs/swagger';
import { NextFunction, Response } from 'express';
import { Auth, Authenticated, FileResponse, SharedLinkRoute } from '../../app.guard';
import { sendFile } from '../../app.utils';
import { UUIDParamDto } from '../../controllers/dto/uuid-param.dto';
import { FileUploadInterceptor, ImmichFile, Route, mapToUploadFile } from '../../interceptors';
import FileNotEmptyValidator from '../validation/file-not-empty-validator';
import { AssetService } from './asset.service';
import { AssetBulkUploadCheckDto } from './dto/asset-check.dto';
import { AssetSearchDto } from './dto/asset-search.dto';
import { CheckExistingAssetsDto } from './dto/check-existing-assets.dto';
import { CreateAssetDto } from './dto/create-asset.dto';
import { DeviceIdDto } from './dto/device-id.dto';
import { GetAssetThumbnailDto } from './dto/get-asset-thumbnail.dto';
import { ServeFileDto } from './dto/serve-file.dto';
import { AssetBulkUploadCheckResponseDto } from './response-dto/asset-check-response.dto';
import { AssetFileUploadResponseDto } from './response-dto/asset-file-upload-response.dto';
import { CheckExistingAssetsResponseDto } from './response-dto/check-existing-assets-response.dto';
import { CuratedLocationsResponseDto } from './response-dto/curated-locations-response.dto';
import { CuratedObjectsResponseDto } from './response-dto/curated-objects-response.dto';

interface UploadFiles {
  assetData: ImmichFile[];
  livePhotoData?: ImmichFile[];
  sidecarData: ImmichFile[];
}

@ApiTags('Asset')
@Controller(Route.ASSET)
@Authenticated()
export class AssetController {
  constructor(private assetService: AssetService) {}

  @SharedLinkRoute()
  @Post('upload')
  @UseInterceptors(FileUploadInterceptor)
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    description: 'Asset Upload Information',
    type: CreateAssetDto,
  })
  async uploadFile(
    @Auth() auth: AuthDto,
    @UploadedFiles(new ParseFilePipe({ validators: [new FileNotEmptyValidator(['assetData'])] })) files: UploadFiles,
    @Body(new ValidationPipe({ transform: true })) dto: CreateAssetDto,
    @Res({ passthrough: true }) res: Response,
  ): Promise<AssetFileUploadResponseDto> {
    const file = mapToUploadFile(files.assetData[0]);
    const _livePhotoFile = files.livePhotoData?.[0];
    const _sidecarFile = files.sidecarData?.[0];
    let livePhotoFile;
    if (_livePhotoFile) {
      livePhotoFile = mapToUploadFile(_livePhotoFile);
    }

    let sidecarFile;
    if (_sidecarFile) {
      sidecarFile = mapToUploadFile(_sidecarFile);
    }

    const responseDto = await this.assetService.uploadFile(auth, dto, file, livePhotoFile, sidecarFile);
    if (responseDto.duplicate) {
      res.status(HttpStatus.OK);
    }

    return responseDto;
  }

  @SharedLinkRoute()
  @Get('/file/:id')
  @FileResponse()
  async serveFile(
    @Res() res: Response,
    @Next() next: NextFunction,
    @Auth() auth: AuthDto,
    @Param() { id }: UUIDParamDto,
    @Query(new ValidationPipe({ transform: true })) dto: ServeFileDto,
  ) {
    await sendFile(res, next, () => this.assetService.serveFile(auth, id, dto));
  }

  @SharedLinkRoute()
  @Get('/thumbnail/:id')
  @FileResponse()
  async getAssetThumbnail(
    @Res() res: Response,
    @Next() next: NextFunction,
    @Auth() auth: AuthDto,
    @Param() { id }: UUIDParamDto,
    @Query(new ValidationPipe({ transform: true })) dto: GetAssetThumbnailDto,
  ) {
    await sendFile(res, next, () => this.assetService.serveThumbnail(auth, id, dto));
  }

  @Get('/curated-objects')
  getCuratedObjects(@Auth() auth: AuthDto): Promise<CuratedObjectsResponseDto[]> {
    return this.assetService.getCuratedObject(auth);
  }

  @Get('/curated-locations')
  getCuratedLocations(@Auth() auth: AuthDto): Promise<CuratedLocationsResponseDto[]> {
    return this.assetService.getCuratedLocation(auth);
  }

  @Get('/search-terms')
  getAssetSearchTerms(@Auth() auth: AuthDto): Promise<string[]> {
    return this.assetService.getAssetSearchTerm(auth);
  }

  /**
   * Get all AssetEntity belong to the user
   */
  @Get('/')
  @ApiHeader({
    name: 'if-none-match',
    description: 'ETag of data already cached on the client',
    required: false,
    schema: { type: 'string' },
  })
  getAllAssets(
    @Auth() auth: AuthDto,
    @Query(new ValidationPipe({ transform: true })) dto: AssetSearchDto,
  ): Promise<AssetResponseDto[]> {
    return this.assetService.getAllAssets(auth, dto);
  }

  /**
   * @deprecated Use /asset/device/:deviceId instead - Remove at 1.92 release
   */
  @Get('/:deviceId')
  @ApiOperation({ deprecated: true, summary: 'Use /asset/device/:deviceId instead - Remove in 1.92 release' })
  getUserAssetsByDeviceId(@Auth() auth: AuthDto, @Param() { deviceId }: DeviceIdDto) {
    return this.assetService.getUserAssetsByDeviceId(auth, deviceId);
  }

  /**
   * Get a single asset's information
   */
  @SharedLinkRoute()
  @Get('/assetById/:id')
  getAssetById(@Auth() auth: AuthDto, @Param() { id }: UUIDParamDto): Promise<AssetResponseDto> {
    return this.assetService.getAssetById(auth, id) as Promise<AssetResponseDto>;
  }

  /**
   * Checks if multiple assets exist on the server and returns all existing - used by background backup
   */
  @Post('/exist')
  @HttpCode(HttpStatus.OK)
  checkExistingAssets(
    @Auth() auth: AuthDto,
    @Body(ValidationPipe) dto: CheckExistingAssetsDto,
  ): Promise<CheckExistingAssetsResponseDto> {
    return this.assetService.checkExistingAssets(auth, dto);
  }

  /**
   * Checks if assets exist by checksums
   */
  @Post('/bulk-upload-check')
  @HttpCode(HttpStatus.OK)
  checkBulkUpload(
    @Auth() auth: AuthDto,
    @Body(ValidationPipe) dto: AssetBulkUploadCheckDto,
  ): Promise<AssetBulkUploadCheckResponseDto> {
    return this.assetService.bulkUploadCheck(auth, dto);
  }
}
