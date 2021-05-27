import { Inject, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Sotong } from './sotong.entity';

@Injectable()
export class SotongService {
    constructor(
        @Inject('SOTONG_REPOSITORY')
        private sotongRepository: Repository<Sotong>,
    ) {}

    /**
     * 리스트 조회
     */
    async findAll(): Promise<Sotong[]> {
        return this.sotongRepository.find();
    }

    /**
     * 리스트 조회
     * @param id
     */
    async findOne(id: number): Promise<Sotong> {
        return this.sotongRepository.findOne({ id: id });
    }

    /**
     * 리스트 저장
     * @param user
     */
    async saveUser(user: Sotong): Promise<void> {
        await this.sotongRepository.save(user);
    }

    /**
     * 리스트 삭제
     * @param id
     */
    async deleteUser(id: number): Promise<void> {
        await this.sotongRepository.delete({ id: id });
    }
}
