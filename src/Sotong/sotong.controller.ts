import {
    Body,
    Controller,
    Delete,
    Get,
    Param,
    Patch,
    Post,
} from '@nestjs/common';
import { get } from 'http';
import { Sotong } from './sotong.entity';
import { SotongService } from './sotong.service';

@Controller()
export class SotongController {
    //sotongService
    constructor(private readonly sotongService: SotongService) {}

    @Get()
    getAll(): Promise<Sotong[]> {
        console.log(this.sotongService.findAll());
        return this.sotongService.findAll();
    }

    @Get('/:id')
    findOne(@Param('id') userId: number): Promise<Sotong> {
        console.log(userId);
        return this.sotongService.findOne(userId);
    }

    @Post()
    userSave(@Body() user: Sotong): Promise<string> {
        this.sotongService.saveUser(user);
        return Object.assign({
            data: { ...user },
            statusCode: 201,
            statusMsg: `saved successfully`,
        });
    }

    @Delete(':userId')
    async deleteUser(@Param('userId') id: number): Promise<string> {
        await this.sotongService.deleteUser(id);
        return Object.assign({
            data: { userId: id },
            statusCode: 201,
            statusMsg: `deleted successfully`,
        });
    }
}
